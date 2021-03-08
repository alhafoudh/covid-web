class SentryFaradayMiddleware < Faraday::Response::Middleware
  def on_complete(env)
    crumb = Sentry::Breadcrumb.new(
      data: { env: env.as_json },
      category: 'faraday',
      message: "Completed request to #{env[:method]} #{env[:url]} with status #{env[:status]}"
    )
    Sentry.add_breadcrumb(crumb)
  end
end
