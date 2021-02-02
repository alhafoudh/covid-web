module NcziClient
  extend ActiveSupport::Concern

  protected

  def base_url
    'https://www.old.korona.gov.sk'
  end

  def nczi_client
    @nczi_client ||= Faraday.new(proxy: Rails.application.config.x.http_proxy) do |faraday|
      faraday.use :instrumentation
      faraday.use Faraday::Response::RaiseError
      faraday.request :json
      faraday.response :json
      faraday.request :retry
      faraday.adapter Faraday.default_adapter
    end
  end
end
