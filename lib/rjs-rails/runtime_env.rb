module RjsRails
  class RuntimeEnv

    attr_accessor :env

    def initialize(env)
      @env = env
      rjs_static_include
    end

    def base_config
      return @base_config if @base_config
      base_config = {
        "baseUrl"      => baseurl,
        "paths"        => paths,
        "shim"         => shims,
        "waitSeconds"  => 0
      } 
    end  

    def user_config
      @user_config ||= load_yml_config
    end

    def config
      @config ||= base_config.merge(user_config)
    end

    def rjs_static_include
      @static_template ||= build_static_include
    end  


    def yml
      env.rjs_runtime_yml
    end  

    def baseurl
      "#{Rails.application.config.asset_host}#{Rails.application.config.assets.prefix}/"
    end

    def module_names
      Rails.application.config.rjs.build_env.module_names
    end

    def shims
      Rails.application.config.rjs.build_env.shims
    end

    def helpers
      ActionController::Base.helpers
    end  

    def module_path(m)
      helpers.javascript_path("#{m}.js").sub(/.js$/,"")
    end  

    def module_paths
      mpaths = {}
      module_names.each { |m| paths[m] = module_path(m) }
      mpaths
    end

    def paths
      module_paths.merge(Rails.application.config.rjs.build_env.paths)
    end

    def static_template
      erb_template = <<-EOF
        <script>var require = <%= JSON.generate(config).html_safe %>;</script>
      EOF
    end

    def build_static_include
      erb = ERB.new(static_template)
      p = Proc.new { config }
      binding = Kernel.binding
      erb.result(binding)
    end  
    
    def load_yml_config
      return {} if not File.exists? yml
      File.open(yml) { |f|
        return YAML.load(f.read)
      }  
    end  

  end  
end  
