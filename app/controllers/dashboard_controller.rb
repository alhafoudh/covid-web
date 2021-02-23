class DashboardController < ApplicationController
  before_action :skip_session, only: [:index, :embed, :region, :other_region]
  before_action :fetch_regions, only: [:jump, :index, :embed, :region]
  before_action :fetch_places, only: [:jump, :embed, :region, :other_region]
  before_action :allow_iframe, only: [:embed]

  layout 'embed', only: [:embed]
  layout 'turbo', only: [:jump, :region, :other_region]

  def jump
    cache_places!
    expire_static!
  end

  def index
    expire_static!
  end

  def region
    @regions = @regions.where(id: params[:region_id] )
    @places = @places.where(region_id: params[:region_id])

    cache_places!
    expire_static!
  end

  def other_region
    @regions = nil
    @places = @places.where(region_id: nil)

    cache_places!
    expire_static!
  end

  def embed
    county_ids = params[:county_ids] || []

    if county_ids.any?
      @regions = @regions
                   .joins(:counties)
                   .where('counties.id IN (?)', county_ids)

      @places = @places
                  .where('county_id IN (?)', county_ids)
    else
      @regions = Region.none
      @places = place_model.none
    end

    cache_places!
  end

  private

  def skip_session
    request.session_options[:skip] = true
  end

  def fetch_regions
    @regions = Region
                 .includes(
                   places_association,
                   :counties,
                 )
                 .order(name: :asc)
  end

  def fetch_places
    @plan_dates = plan_date_model
                    .where('date >= ? AND date <= ?', Date.today, Date.today + num_plan_date_days)
                    .order(date: :asc)

    @places = place_model
                .enabled
                .includes(
                  :region, :county,
                  latest_snapshots: [
                    :plan_date,
                    { snapshot: [:plan_date] }
                  ]
                )
                .where(latest_snapshots: {
                  plan_date_snapshot_foreign_key => @plan_dates.pluck(:id)
                })
                .order(title: :asc)
  end

  def cache_places!
    if stale?(@places, public: true)
      @places_by_county = @places.group_by(&:county)
    end
  end

  def expire_static!
    if Rails.env.production?
      expires_in(Rails.application.config.x.cache.content_expiration_minutes, public: true, stale_while_revalidate: Rails.application.config.x.cache.content_stale_minutes)
    end
  end

  def plan_date_snapshot_foreign_key
    raise NotImplementedError
  end

  def place_model
    raise NotImplementedError
  end

  def places_association
    raise NotImplementedError
  end

  def plan_date_model
    raise NotImplementedError
  end

  def num_plan_date_days
    raise NotImplementedError
  end
end