Sentry.init do |config|
  config.breadcrumbs_logger = [:active_support_logger]

  config.traces_sample_rate = 1.0

  filter = ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters)
  config.before_send = lambda do |event, hint|
    event.request.data = filter.filter(event.request.data)
    event
  end
end