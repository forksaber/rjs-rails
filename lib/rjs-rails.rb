require 'rjs-rails/env'
require 'rjs-rails/build_env'
require 'rjs-rails/runtime_env'
require 'rjs-rails/rjs_helpers'

module RjsRails
end
require 'rjs-rails/railtie' if defined?(Rails)
