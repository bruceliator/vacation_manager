require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module VacationManager
  class Application < Rails::Application
    config.autoload_paths += %W["#{config.root}/app/validators/"]
    config.active_job.queue_adapter = :delayed_job
  end
end

require 'workdays'
