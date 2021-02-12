Sentry.init do |config|
  # filter = ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters)
  # config.before_send = lambda do |event, _hint|
  #   request_data = event.request&.data&.is_a?(String) ? JSON.parse(event.request.data) : event.request&.data
  #   event.request.data = filter.filter(request_data) unless request_data.nil?
  #   event
  # end
  config.send_default_pii = true
  config.excluded_exceptions += %w{
    ActiveRecord::RecordInvalid
    ActiveRecord::RecordNotFound
    ActionController::ParameterMissing
  }.freeze
  config.breadcrumbs_logger = [:active_support_logger]
  config.rails.report_rescued_exceptions = true

  config.traces_sample_rate = 0.1
end
