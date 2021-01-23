module RychlejsieClient
  extend ActiveSupport::Concern

  protected

  def rychlejsie_client
    @rychlejsie_client ||= Faraday.new do |faraday|
      faraday.use :instrumentation
      faraday.use Faraday::Response::RaiseError
      faraday.response :json
      faraday.adapter Faraday.default_adapter
    end
  end
end
