require 'rjs-rails/runtime/config'
module RjsRails
  module Runtime
    class Api

      attr_writer :env

      def initialize(env = nil)
        self.env = env
      end

      def static_include
        @static_include ||= config.static_include
      end

      def reload!
        @config = nil
        @static_include = config.static_include
      end

      def config
        @config ||= ::RjsRails::Runtime::Config.new(env)
      end

      def env
        @env ||= ::RjsRails::Env.new
      end

    end
  end  
end  
