module RjsRails
  class Railtie < Rails::Railtie
    initializer "rjs_rails.configure_rails_initialization" do
      config.rjs = RjsRails::Env.new
      ActionView::Base.send :include, RjsRails::RjsHelpers
    end

    config.to_prepare do
      Rails.application.config.rjs.reload!
    end

    rake_tasks do
      load File.expand_path("../tasks/rjs-rails.rake", File.dirname(__FILE__))
    end

  end
end  