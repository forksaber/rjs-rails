require 'rjs-rails/build/config'

module RjsRails
  module Runtime
    class Config

      attr_accessor :env, :build_config

      def initialize(env = nil)
        self.env = env
      end

      def static_include
        @static_include ||= template
      end  

      def template
        "<script>var require = #{JSON.generate(config)}</script>"
      end

      def module_paths
        mpaths = {}
        build_config.module_names.map{ |m| mpaths[m] = module_path(m) }
        return mpaths
      end

      def paths
        paths = build_config.paths
        paths.merge(module_paths)
      end

      def module_path(m)
        helper.javascript_path(m).sub(/.js$/,'')
      end

      
      def helper
        @helper ||= begin
          proxy = ::ActionView::Base.new
          proxy.config = ::ActionController::Base.config.inheritable_copy
          proxy.extend(::ActionController::Base._helpers)
        end
      end

      private

      def env
        @env ||= ::RjsRails::Env.new
      end

      def build_config
        @build_config ||= ::RjsRails::Build::Config.new(env)
      end


      def config_path
        @config_path ||= Pathname.new(env.runtime_yml)
      end

      def load_config
        return {} if not config_path.readable?
        File.open config_path do |f|
          YAML.load f.read
        end
      end  

      def baseurl
        "#{Rails.application.config.asset_host}#{Rails.application.config.assets.prefix}/"
      end

      def base_config
        base_config = ({
          "baseUrl"      => baseurl,
          "paths"        => paths,
          "shim"         => build_config.shims,
          "waitSeconds"  => 0
        })
      end  

      def user_config
        @user_config ||= load_config
      end

      def config
        @config ||= base_config.merge(user_config)
      end  

    end
  end
end
