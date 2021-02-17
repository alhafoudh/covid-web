module RychlejsieClient
  extend ActiveSupport::Concern

  protected

  def rychlejsie_client
    @rychlejsie_client ||= Faraday.new(proxy: Rails.application.config.x.http_proxy) do |faraday|
      faraday.use :instrumentation
      faraday.use Faraday::Response::RaiseError
      faraday.response :json
      faraday.response :logger, nil, { headers: false, bodies: false }
      faraday.request :retry
      faraday.adapter Faraday.default_adapter
    end
  end
end
