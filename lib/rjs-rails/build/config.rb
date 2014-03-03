module RjsRails
module Build
  class Config

    attr_writer :env

    def initialize(env = nil)
      self.env = env
    end

    def config
      @config ||= base_config.merge(user_config)
    end  

    def to_h
      config
    end

    def modules
      config.fetch "modules", []
    end  

    def module_names
      modules.collect { |m| m["name"] }
    end

    def shims
      config.fetch "shim", {}
    end

    def paths
      config.fetch "paths", {}
    end  

    def assets_for_precompile
      js = []
      js << 'require.js'
      module_names.each { |m| js << "#{m}.js" }
      js
    end  

    private

    def env
      @env ||= ::RjsRails::Env.new
    end

    def config_path
      @config_path ||= Pathname.new(env.build_yml)
    end

    def readable?
      config_path.readable?
    end  


    def load_config
      return {} if not readable?
      File.open config_path do |f|
        YAML.load f.read
      end
    end  

    def base_config
      base_config = ::Hash.new {
        "baseUrl"             => env.source_dir,
        "dir"                 => env.build_dir,
        "optimize"            => "none",
        "skipDirOptimize"     => true,
        "keepBuildDir"        => false,
        "normalizeDirDefines" => "skip"
      } 
    end  

    def user_config
      @user_config ||= load_config
    end

  end
end
