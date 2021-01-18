class ApplicationService
  def logger
    @logger ||= Rails.logger.tagged(self.class.to_s)
  end
end