module Testing
  class DashboardController < ::DashboardController
    private

    def plan_date_snapshot_foreign_key
      :test_date_id
    end

    def place_model
      Mom
    end

    def places_association
      :moms
    end

    def plan_date_model
      TestDate
    end

    def num_plan_date_days
      Rails.application.config.x.testing.num_plan_date_days
    end
  end
end