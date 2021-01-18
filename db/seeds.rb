Rails.logger = Logger.new($stdout)

class Seeds
  GROUPS = {
    all: %i[moms regions counties test_dates],
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
    @test_dates = (Date.new(2021, 1, 19)...Date.new(2021, 1, 26)).map do |date|
      {
        date: date,
        created_at: Time.zone.now,
        updated_at: Time.zone.now,
      }
    end

    TestDate.insert_all!(test_dates)
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
