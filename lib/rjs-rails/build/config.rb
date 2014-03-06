module RjsRails
module Build
  class Config

    attr_accessor :env

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

    def sources
      sources = []
      module_names.each { |m| sources << "#{m}.js" }
      paths_hash = paths
      shims.each do |key, _|
        if paths_hash.has_key? key
          sources << "#{paths_hash[key]}.js"
        else
          sources << "#{key}.js"
        end
      end
      return sources
    end

    def assets_for_precompile
      js = []
      js << 'require.js'
      module_names.each { |m| js << "#{m}.js" }
      js
    end

    def precompile_required?
      ! user_config.empty?
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
      base_config = ({
        "baseUrl"             => env.sources_dir,
        "dir"                 => env.build_dir,
        "optimize"            => "none",
        "skipDirOptimize"     => true,
        "keepBuildDir"        => false,
        "normalizeDirDefines" => "skip"
      })
    end  

    def user_config
      @user_config ||= load_config
    end

  end
end
end
