module RjsRails
  module RjsHelpers

    def rjs_include_tag(js)
      tag = rjs_static_include + rjs_dynamic_template(js)
      tag.html_safe
    end

    def rjs_static_include
      rjs_runtime.rjs_static_include
    end  

    def rjs_dynamic_template(js)
      "<script data-main=\"#{rjs_javascript_path(js)}\" src=\"#{javascript_path "require.js"}\"></script>"
    end
  
    def rjs_javascript_path(js)
      path = javascript_path(js).sub(/^#{rjs_baseurl}/,'')
      path = path.sub(/.js$/,'')
      path
    end

    def rjs_baseurl()
      rjs_runtime.baseurl
    end

    def rjs_runtime
      Rails.application.config.rjs.runtime_env
    end  

  end  
end  
