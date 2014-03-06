module RjsRails
  class Env
    
    attr_accessor :sources_dir, :build_dir, :build_js
    attr_accessor :build_yml, :sources_yml, :rjs_path
    attr_accessor :template, :runtime_yml


    def initialize
      self.sources_dir = rails_path "tmp/assets_source_dir"
      self.build_dir = rails_path "tmp/assets_build_dir"
      self.build_js = rails_path "tmp/build.js" 
      self.build_yml = rails_path "config/rjs/build.yml"
      self.sources_yml = rails_path "config/rjs/sources.yml"
      self.runtime_yml = rails_path "config/rjs/runtime.yml"
      self.rjs_path = relative_path "../../vendor/assets/javascripts/r.js"
      self.template = relative_path "./build.js.erb"
    end

    def relative_path(path)
      dir = File.dirname(__FILE__)
      File.expand_path path, dir
    end

    def rails_path(path)
      "#{Rails.root}/#{path}"
    end

  end
end
