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
      faraday.use :instrumentation
      faraday.use Faraday::Response::RaiseError
      faraday.request :json
      faraday.response :json
      faraday.response :logger, Rails.logger, { headers: false, bodies: false }
      faraday.request :retry
      faraday.adapter Faraday.default_adapter
    end
  end
end