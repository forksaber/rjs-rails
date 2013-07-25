module RjsRails
  class BuildEnv

    attr_accessor :env

    def initialize(env)
      @env = env
      config
    end

    def base_config
      return @base_config if @base_config
      base_config = {
        "baseUrl"             => env.source_dir,
        "dir"                 => env.build_dir,
        "optimize"            => "none",
        "skipDirOptimize"     => true,
        "keepBuildDir"        => false,
        "normalizeDirDefines" => "skip"
      } 
    end  

    def user_config
      @user_config ||= load_yml_config
    end

    def config
      @config ||= base_config.merge(user_config)
    end  

    def modules
      config["modules"] || []
    end  

    def module_names
      modules.collect { |m| m["name"] }
    end

    def yml_exists?
      File.exists? yml
    end  

    def shims
      config["shim"] || {}
    end

    def paths
      config["paths"] || {}
    end  

    def assets_for_precompile
      js = []
      js << 'require.js'
      modules.each { |m| js << "#{m["name"]}.js" }
      js
    end  

    private

    def yml
      env.rjs_build_yml
    end  

    def load_yml_config
      return {} if not File.exists? yml
      File.open(yml) { |f|
        return YAML.load(f.read)
      }  
    end  

  end  
end  
