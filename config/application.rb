require_relative "boot"

require 'active_record/railtie'
# require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'action_mailer/railtie'
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

    config.active_job.queue_adapter = :sidekiq

    # Enable following when action_mailer and active_storage are used
    # config.action_mailer.deliver_later_queue_name = nil
    # config.active_storage.queues.analysis   = nil
    # config.active_storage.queues.purge      = nil
    # config.active_storage.queues.mirror     = nil

    config.hosts = nil

    config.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
    config.log_level = ENV.fetch('LOG_LEVEL', :info).to_sym

    config.middleware.use Rack::Deflater

    config.x.prometheus.enabled = ENV.fetch('PROMETHEUS_ENABLED', 'false') == 'true'
    config.x.sidekiq.status_expiration = ENV.fetch('SIDEKIQ_STATUS_EXPIRATION', 240).to_i.minutes
    config.x.sentry.dsn = ENV.fetch('SENTRY_DSN', nil)
    config.x.sentry.traces_sample_rate = ENV.fetch('SENTRY_TRACES_SAMPLE_RATE', '0.01').to_f
    config.x.sentry.js_dsn = ENV.fetch('SENTRY_JS_DSN', nil)

    config.x.redirects = JSON.parse(ENV.fetch('REDIRECTS', '{}'))
    config.x.http_proxy = ENV.fetch('http_proxy', nil)
    config.x.update_interval = ENV.fetch('UPDATE_INTERVAL', 15).to_i

    config.x.analytics.gtm_code = ENV.fetch('ANALYTICS_GTM_CODE', nil)

    config.x.firebase.api_key = ENV.fetch('FIREBASE_API_KEY', nil)
    config.x.firebase.project_id = ENV.fetch('FIREBASE_PROJECT_ID', nil)
    config.x.firebase.sender_id = ENV.fetch('FIREBASE_SENDER_ID', nil)
    config.x.firebase.app_id = ENV.fetch('FIREBASE_APP_ID', nil)
    config.x.firebase.vapid_key = ENV.fetch('FIREBASE_VAPID_KEY', nil)
    config.x.firebase.server_key = ENV.fetch('FIREBASE_SERVER_KEY', nil)
    config.x.firebase.credentials_json = ENV.fetch('FIREBASE_CREDENTIALS_JSON', nil)

    config.x.status.content_expiration = ENV.fetch('STATUS_CONTENT_EXPIRATION_SECONDS', 5).to_i

    config.x.nczi.use_proxy = ENV.fetch('NCZI_USE_PROXY', 'false') == 'true'
    config.x.nczi.use_batch_api = ENV.fetch('NCZI_USE_BATCH_API', 'false') == 'true'

    config.x.testing.num_plan_date_days = ENV.fetch('TESTING_NUM_PLAN_DATE_DAYS', 10).to_i
    config.x.testing.update_interval = ENV.fetch('UPDATE_TEST_DATE_SNAPSHOTS_INTERVAL', 15).to_i
    config.x.testing.rate_limit = ENV.fetch('UPDATE_TEST_DATE_SNAPSHOTS_RATE_LIMIT', 1).to_f

    config.x.vaccination.num_plan_date_days = ENV.fetch('VACCINATION_NUM_PLAN_DATE_DAYS', 10).to_i
    config.x.vaccination.update_interval = ENV.fetch('UPDATE_VACCINATION_DATE_SNAPSHOTS_INTERVAL', 15).to_i
    config.x.vaccination.rate_limit = ENV.fetch('UPDATE_VACCINATION_DATE_SNAPSHOTS_RATE_LIMIT', 1).to_f

    config.x.cache.content_expiration_minutes = ENV.fetch('CACHED_CONTENT_EXPIRATION_MINUTES', 15).to_i.minutes
    config.x.cache.content_stale_minutes = ENV.fetch('CACHED_CONTENT_STALE_MINUTES', 1).to_i.minutes

    config.x.messenger.page_id = ENV.fetch('MESSENGER_PAGE_ID')
    config.x.messenger.access_token = ENV.fetch('MESSENGER_ACCESS_TOKEN')
    config.x.messenger.verify_token = ENV.fetch('MESSENGER_VERIFY_TOKEN')
    config.x.messenger.app_secret = ENV.fetch('MESSENGER_APP_SECRET')

    config.x.notifications.enabled = ENV.fetch('NOTIFICATIONS_ENABLED', 'false') == 'true'
    config.x.notifications.link_host = ENV.fetch('NOTIFICATIONS_LINK_HOST')
    config.x.notifications.free_capacity_threshold = ENV.fetch('NOTIFICATIONS_FREE_CAPACITY_THRESHOLD', 10).to_i

    config.middleware.use Rack::HostRedirect, config.x.redirects

    config.i18n.available_locales = [:sk]

    def prometheus
      yield if block_given? && Rails.application.config.x.prometheus.enabled
    end
  end
end
