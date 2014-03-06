module RjsRails
  module RjsHelpers

    def rjs_include_tag(js)
      tag = "#{rjs_static_include} #{rjs_dynamic_template(js)}"
      tag.html_safe
    end

    def rjs_static_include
      rjs_runtime.static_include
    end  

    def rjs_dynamic_template(js)
      "<script data-main=\"#{rjs_javascript_path(js)}\" src=\"#{javascript_path "require.js"}\"></script>"
    end
  
    def rjs_javascript_path(js)
      js.sub(/.js$/,'')
    end

    def rjs_runtime
      Rails.application.config.rjs_runtime
    end  

  end  
end  
