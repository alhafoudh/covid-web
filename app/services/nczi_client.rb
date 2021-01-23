module NcziClient
  extend ActiveSupport::Concern

  protected

  def base_url
    'https://www.old.korona.gov.sk'
  end

  def nczi_client
    @nczi_client ||= Faraday.new do |faraday|
      faraday.use :instrumentation
      faraday.use Faraday::Response::RaiseError
      faraday.request :json
      faraday.response :json
      faraday.adapter Faraday.default_adapter
    end
  end
end
