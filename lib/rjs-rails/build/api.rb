module RjsRails
  module Build
    class Api
      
      def initialize

      end

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
          puts "#{i}/#{num_assets} #{logical_path}"
          write_asset logical_path
        end
      end


      def generate_build_js
        puts "=> generating build.js"
        template = env.template
        output_file = env.build_js
        File.open(template) do |f|
          erb = ERB.new(f.read)
          File.open(output_file , 'w') { |of|
            of.write erb.result(binding)
          }
        end
      end


      def optimize
        command = "node #{env.build_js}"
        IO.popen(command) do |f|
          f.each { |line| puts line }
        end
      end

      def prepend_path
        assets_env = Rails.application.assets.instance_variable_get("@environment")
        assets_env.prepend_path env.build_dir
      end

      def add_assets_for_precompile
         assets_array = config.assets_for_precompile
         Rails.application.config.assets.precompile.concat(assets_array)
      end


      def config
        @config ||= Config.new(env) 
      end

      def assets
        @assets ||= ::RjsRails::Sprockets.new.index
      end

      def sources
        @sources || ::RjsRails::Sources.new(env)
      end

      private

      def empty_dirs
        puts "Emptying #{env.source_dir}"
        FileUtils.remove_entry_secure(env.source_dir, true)
        FileUtils.mkpath env.source_dir
      
        puts "Emptying #{env.build_dir}"
        FileUtils.remove_entry_secure(env.build_dir, true)
        FileUtils.mkpath env.build_dir
      end

      def logical_paths
        sources.paths
      end

      def write_asset(logical_path)
       if asset = assets.find_asset logical_path
          filename = "#{source_dir}/#{logical_path}"
          asset.write_to(filename)
        else
          puts "WARNING could not find #{logical_path}"
        end
      end

      def asset_paths
        @asset_paths ||= assets.each_logical_path (logical_paths)
      end

      def num_assets
        @num_assets ||= asset_paths.count
      end


    end
  end
end
