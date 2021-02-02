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

    config.x.http_proxy = ENV.fetch('http_proxy', nil)

    config.x.testing.update_interval = ENV.fetch('UPDATE_TEST_DATE_SNAPSHOTS_INTERVAL', 15).to_i
    config.x.testing.rate_limit = ENV.fetch('UPDATE_TEST_DATE_SNAPSHOTS_RATE_LIMIT', 1).to_i
    config.x.vaccination.update_interval = ENV.fetch('UPDATE_VACCINATION_DATE_SNAPSHOTS_INTERVAL', 15).to_i
    config.x.vaccination.rate_limit = ENV.fetch('UPDATE_VACCINATION_DATE_SNAPSHOTS_RATE_LIMIT', 1).to_i
    config.x.cache.content_expiration_minutes = ENV.fetch('CACHED_CONTENT_EXPIRATION_MINUTES', 15).to_i.minutes
    config.x.cache.content_stale_minutes = ENV.fetch('CACHED_CONTENT_STALE_MINUTES', 1).to_i.minutes

    config.x.messenger.page_id = ENV.fetch('MESSENGER_PAGE_ID')
    config.x.messenger.access_token = ENV.fetch('MESSENGER_ACCESS_TOKEN')
    config.x.messenger.verify_token = ENV.fetch('MESSENGER_VERIFY_TOKEN')
    config.x.messenger.app_secret = ENV.fetch('MESSENGER_APP_SECRET')
    config.x.messenger.link_host = ENV.fetch('MESSENGER_LINK_HOST')

    config.x.redirects = JSON.parse(ENV.fetch('REDIRECTS', '{}'))
    config.middleware.use Rack::HostRedirect, config.x.redirects

    config.i18n.available_locales = [:sk]
  end
end
