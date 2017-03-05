require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module VacationManager
  class Application < Rails::Application
    config.autoload_paths += %W["#{config.root}/app/validators/"]
  end
end

require 'workdays'
