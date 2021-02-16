if Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash(Rails.application.config_for('schedule'))
end