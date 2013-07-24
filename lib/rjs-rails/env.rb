module RjsRails
  class Env
    
    def config
      return @conf if @conf
      c = ::ActiveSupport::OrderedOptions.new
      c.extensions         = [/.js$/]
      c.source_dir         = "#{Rails.root}/tmp/assets_source_dir"
      c.build_dir   = "#{Rails.root}/tmp/assets_build_dir"
      c.rjs_build_yml   = "#{Rails.root}/config/rjs_build.yml"
      c.rjs_runtime_yml = "#{Rails.root}/config/rjs_runtime.yml"
      c.rjs_path           = File.expand_path("../../vendor/assets/javascripts/r.js", File.dirname(__FILE__))
      c.template           = File.expand_path("./build.js.erb", File.dirname(__FILE__))
      c.build_js           = "#{Rails.root}/tmp/build.js"
      @conf = c
    end  

    def build_env
      @build_env ||= RjsRails::BuildEnv.new(config)
    end

    def runtime_env
      @runtime_env ||= RjsRails::RuntimeEnv.new(config)
    end  

    def reload!
      @build_env = nil
      @runtime_env = nil
      build_env
      runtime_env
    end

    def get_binding()
      binding()
    end  

    def precompile_required?
      build_env.yml_exists?
    end

    def assets_for_precompile
      build_env.assets_for_precompile
    end  

  end
end  
