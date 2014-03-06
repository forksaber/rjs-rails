require 'rjs-rails/env'
require 'rjs-rails/sources'
require 'rjs-rails/sprockets'
require 'rjs-rails/build/config'

module RjsRails
  module Build
    class Api
      
      def env
        @env ||= ::RjsRails::Env.new
      end

      def precompile
        copy_sources
        generate_build_js
        optimize
        prepend_path
        add_assets_for_precompile
      end

      def copy_sources
        empty_dirs
        puts "=> copying sources"
        asset_paths.each_with_index do |logical_path, i|
          cr = "\r"
          clear = "\e[0K"
          print cr
          print clear
          print "#{i+1}/#{num_assets} #{logical_path}"
          write_asset logical_path
        end
        puts
      end


      def generate_build_js
        puts "=> generating build.js"
        template = env.template
        output_file = env.build_js
        File.open(template) do |f|
          erb = ERB.new(f.read)
          File.open(output_file , 'w') do |of|
            of.write erb.result(binding)
          end
        end
      end

      def optimize
        puts "=> optimizing "
        command = "node #{env.build_js}"
        IO.popen(command) do |f|
          f.each { |line| puts line }
        end
      end

      def prepend_path
        puts "=> prepend_path"
        assets_env = sprockets.rails_assets_env
        assets_env.prepend_path env.build_dir
        case Rails.env
        when "development"
          Rails.application.assets = assets_env
        else
          Rails.application.assets = assets_env.index
        end
      end

      def add_assets_for_precompile
        puts "=> auto adding assets for precompile"
        assets_array = config.assets_for_precompile
        Rails.application.config.assets.precompile.concat(assets_array)
      end


      def config
        @config ||= Config.new(env) 
      end

      def config_hash
        config.to_h
      end

      def assets
        @assets ||= sprockets.index
      end

      def sources
        @sources || ::RjsRails::Sources.new(env)
      end

      def reload!
        @env = nil
        @sources = nil
        @assets = nil
        @config = nil
        @asset_paths = nil
        @num_assets = nil
      end

      private

      def empty_dirs
        puts "Emptying #{env.sources_dir}"
        FileUtils.remove_entry_secure(env.sources_dir, true)
        FileUtils.mkpath env.sources_dir
      
        puts "Emptying #{env.build_dir}"
        FileUtils.remove_entry_secure(env.build_dir, true)
        FileUtils.mkpath env.build_dir
      end

      def logical_paths
        sources.paths + config.sources
      end

      def write_asset(logical_path)
       if asset = assets.find_asset(logical_path)
          filename = "#{env.sources_dir}/#{logical_path}"
          asset.write_to(filename)
        else
          puts "WARNING could not find #{logical_path}"
        end
      end

      def asset_paths
        @asset_paths ||= assets.each_logical_path(logical_paths)
      end

      def num_assets
        @num_assets ||= asset_paths.count
      end

      def sprockets
        @sprockets ||= ::RjsRails::Sprockets.new
      end

    end
  end
end
