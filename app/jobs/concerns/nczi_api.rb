module NcziApi
  extend ActiveSupport::Concern

  protected

  def base_url
    if Rails.application.config.x.nczi.use_proxy
      'https://data.korona.gov.sk/ncziapi'
    else
      'https://mojeezdravie.nczisk.sk/api/v1/web'
    end
  end

  def nczi_client
    Faraday.new(proxy: Rails.application.config.x.http_proxy) do |faraday|
      faraday.use SentryFaradayMiddleware
      faraday.use :instrumentation
      faraday.use Faraday::Response::RaiseError
      faraday.request :json
      faraday.response :json
      faraday.response :logger, Rails.logger, { headers: false, bodies: false }
      faraday.request :retry
      faraday.adapter Faraday.default_adapter
    end
  end

  def nczi_get_payload(url)
    response = nczi_client.get(url)
    body = response.body
    if response.status == 200 && body.present? && body.has_key?('payload')
      body.fetch('payload')
    else
      raise "Wrong HTTP response. GET #{url.inspect} HTTP status #{response.status} with body: #{body.inspect}"
    end
  end
end