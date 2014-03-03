module RjsRails
  class Sprockets

    def index
      env.index
    end

    def env
      @env ||= custom_sprockets_env
    end

    def rails_assets
      @rails_assets ||= Rails.application.assets
    end

    def custom_sprockets_env
      if rails_assets.is_a? ::Sprockets::Index
        env = rails_assets.instance_variable_get "@environment"
      else
        env = rails_assets
      end
      custom_env = env.clone
      path = "tmp/cache/rjs_assets#{::Rails.env}"
      custom_env.cache = ActiveSupport::Cache::FileStore.new(path)
      custom_env.js_compressor = nil
    end



  end
end
