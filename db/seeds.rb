Rails.logger = Logger.new($stdout)

class Seeds
  GROUPS = {
    all: %i[moms regions counties test_dates test_date_snapshots latest_test_date_snapshots],
    common: [],
  }.freeze

  def run(group = :all)
    Faker::Config.locale = :sk
    Faker::Config.random = Random.new(1)

    seeds = GROUPS.fetch(group, [])

    log 'Starting to seed %s ...' % seeds.join(', ')

    seeds.map do |seed|
      log 'Seeding %s' % seed
      send(:"seed_#{seed}")
      log 'Done seeding %s' % seed
    end

    log 'Done'
  end

  private

  attr_reader :moms

  def seed_moms
    json = JSON.parse(File.read(Rails.root.join('db/fixtures/moms.json')))
    @moms = json.map do |mom|
      mom
        .symbolize_keys
        .merge(
          created_at: Time.zone.now,
          updated_at: Time.zone.now,
        )
    end

    Mom.insert_all!(moms)
  end

  attr_reader :regions

  def seed_regions
    @regions = Mom
                 .pluck(:region_id, :region_name)
                 .uniq
                 .reject do |(region_id, _)|
      region_id.nil?
    end
                 .map do |(region_id, region_name)|
      {
        id: region_id,
        name: region_name,
        created_at: Time.zone.now,
        updated_at: Time.zone.now,
      }
    end

    Region.insert_all!(regions)

    Region.find_each do |region|
      Region.reset_counters(region.id, :moms)
    end
  end

  attr_reader :counties

  def seed_counties
    @counties = Mom
                  .pluck(:region_id, :county_id, :county_name)
                  .uniq
                  .reject do |(_, county_id, _)|
      county_id.nil?
    end
                  .map do |(region_id, county_id, county_name)|
      {
        region_id: region_id,
        id: county_id,
        name: county_name,
        created_at: Time.zone.now,
        updated_at: Time.zone.now,
      }
    end

    County.insert_all!(counties)

    County.find_each do |county|
      County.reset_counters(county.id, :moms)
    end
  end

  attr_reader :test_dates

  def seed_test_dates
    @test_dates = (Date.new(2021, 1, 19)..Date.new(2021, 1, 26)).map do |date|
      {
        date: date,
        created_at: Time.zone.now,
        updated_at: Time.zone.now,
      }
    end

    TestDate.insert_all!(test_dates)
  end

  attr_reader :test_date_snapshots, :latest_test_date_snapshots

  def seed_test_date_snapshots
    test_dates = TestDate.all
    num_slots = (22 - 8).hours / 15.minutes
    # num_slots = (22 - 8).hours / 1.hour

    @latest_test_date_snapshots = []

    @test_date_snapshots = Mom.all.map do |mom|
      test_dates.map do |test_date|
        num_slots.times.map do |i|
          is_closed = Faker::Number.between(from: 1, to: 100) > 80
          is_minus_1 = Faker::Number.between(from: 1, to: 100) > 95

          free_capacity =
            if is_closed
              0
            else
              is_minus_1 ? -1 : Faker::Number.between(from: 0, to: 10)
            end

          snapshot_at = test_date.date + 8.hours + (i * num_slots)

          {
            mom_id: mom.id,
            test_date_id: test_date.id,

            is_closed: is_closed,
            free_capacity: free_capacity,

            created_at: snapshot_at,
            updated_at: snapshot_at,
          }
        end
      end.flatten
    end.flatten

    TestDateSnapshot.insert_all!(test_date_snapshots)
  end

  attr_reader :latest_test_date_snapshots

  def seed_latest_test_date_snapshots
    latest_test_date_snapshots_map = {}
    TestDateSnapshot.order(created_at: :asc).find_each do |test_date_snapshot|
      latest_test_date_snapshots_map[[test_date_snapshot.test_date_id, test_date_snapshot.mom_id]] = test_date_snapshot
    end
    @latest_test_date_snapshots = latest_test_date_snapshots_map.map do |(test_date_id, mom_id), latest_test_date_snapshot|
      {
        mom_id: mom_id,
        test_date_id: test_date_id,
        test_date_snapshot_id: latest_test_date_snapshot.id,
        created_at: Time.zone.now,
        updated_at: Time.zone.now,
      }
    end

    LatestTestDateSnapshot.insert_all!(latest_test_date_snapshots)
  end

  def log(*args)
    Rails.logger.info(*args)
  end
end

ActiveRecord::Base.transaction do
  Seeds.new.run(
    ENV.fetch('GROUP', :all).to_sym,
  )
end
