module Testing
  module Rychlejsie
    class UpdateMoms < ApplicationJob
      def perform
        logger.info 'Updating all Rychlejsie Moms'

        RychlejsieMom.instances.map do |config|
          UpdateInstanceMoms.perform_now(config)
        end

        logger.info 'Done updating all Rychlejsie Moms'
      end
    end
  end
end