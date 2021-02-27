module VacuumlabsApi
  extend ActiveSupport::Concern

  protected

  def base_url
    'https://rychlotest-covid.sk/api/public'
  end

  def vacuumlabs_client
    Faraday.new do |faraday|
      faraday.use :instrumentation
      faraday.use Faraday::Response::RaiseError
      faraday.request :json
      faraday.response :json
      faraday.response :logger, Rails.logger, { headers: false, bodies: false }
      faraday.adapter Faraday.default_adapter
    end
  end
end