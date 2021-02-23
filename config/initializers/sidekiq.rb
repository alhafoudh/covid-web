require 'sidekiq'
require 'sidekiq-status'

if Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash(Rails.application.config_for('schedule'))
end

Sidekiq.configure_client do |config|
  Sidekiq::Status.configure_client_middleware config, expiration: Rails.application.config.x.sidekiq.status_expiration
end

Sidekiq.configure_server do |config|
  Rails.application.prometheus do
    config.server_middleware do |chain|
      require 'prometheus_exporter/instrumentation'
      chain.add PrometheusExporter::Instrumentation::Sidekiq
    end
    config.death_handlers << PrometheusExporter::Instrumentation::Sidekiq.death_handler

    config.on :startup do
      require 'prometheus_exporter/instrumentation'
      PrometheusExporter::Instrumentation::Process.start(type: 'worker')
      PrometheusExporter::Instrumentation::SidekiqQueue.start
      PrometheusExporter::Instrumentation::ActiveRecord.start(
        custom_labels: { type: 'worker' }, #optional params
        config_labels: [:database, :host] #optional params
      )
    end

    at_exit do
      PrometheusExporter::Client.default.stop(wait_timeout_seconds: 10)
    end
  end

  Sidekiq::Status.configure_server_middleware(config, expiration: Rails.application.config.x.sidekiq.status_expiration)
  Sidekiq::Status.configure_client_middleware(config, expiration: Rails.application.config.x.sidekiq.status_expiration)
end
