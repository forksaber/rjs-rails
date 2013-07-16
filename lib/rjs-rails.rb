require 'rjs-rails/config.rb'

module RjsRails
  def self.init
    if ENV['rjs'] 
      puts "requirejs detected"
      rjs = RjsRails::Config.new
      js_array = rjs.additional_assets_for_precompile
      Rails.application.assets.prepend_path(rjs.config.assets_build_dir)
      Rails.application.config.assets.precompile.concat(js_array)
    end 
  end
end
