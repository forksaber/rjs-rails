module RjsRails
  class Env
    
    attr_writer :rails_root 

    def env
      @env ||= ::Hash.new({
        sources_dir:     rails_path "tmp/assets_source_dir",
        build_dir:       rails_path "tmp/assets_build_dir",
        build_js:        rails_path "tmp/build.js",
        build_yml:       rails_path "config/rjs/build.yml",
        sources_yml:     rails_path "config/rjs/sources.yml",
        rjs_path:        File.expand_path("../../vendor/assets/javascripts/r.js", File.dirname(__FILE__)),
        template:        File.expand_path("./build.js.erb", File.dirname(__FILE__))
      })
    end

    def to_h
      env
    end

    def rails_path(path)
      "#{Rails.root}/#{path}"
    end

  end
end
