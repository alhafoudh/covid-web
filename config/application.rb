require_relative "boot"

require 'active_record/railtie'
# require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_view/railtie'
# require 'action_mailer/railtie'
require 'active_job/railtie'
# require 'action_cable/engine'
# require 'action_mailbox/engine'
# require 'action_text/engine'
require 'rails/test_unit/railtie'
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SkCovidTesting
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = 'Bratislava'
    # config.eager_load_paths << Rails.root.join("extras")
    config.i18n.default_locale = :sk

    config.generators do |g|
      g.assets false
      g.helper false
      g.test_framework nil
      g.jbuilder false
    end

    config.hosts = nil

    config.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
    config.log_level = ENV.fetch('LOG_LEVEL', :info).to_sym

    config.middleware.use Rack::Deflater
  end
end
