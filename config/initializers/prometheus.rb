Rails.application.prometheus do
  require 'prometheus_exporter/middleware'
  require 'prometheus_exporter/instrumentation'

  # this reports basic process stats like RSS and GC info, type master
  # means it is instrumenting the master process
  PrometheusExporter::Instrumentation::Process.start(type: "master")

  # This reports stats per request like HTTP status and timings
  Rails.application.middleware.unshift PrometheusExporter::Middleware
end