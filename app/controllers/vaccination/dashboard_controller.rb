module Vaccination
  class DashboardController < ::DashboardController
    private

    def plan_date_snapshot_foreign_key
      :vaccination_date_id
    end

    def place_model
      Vacc
    end

    def places_association
      :vaccs
    end

    def plan_date_model
      VaccinationDate
    end

    def num_plan_date_days
      Rails.application.config.x.vaccination.num_plan_date_days
    end
  end
end