require 'rails_helper'

describe ApplyOverride do
  let!(:record) do
    {
      title: "AG Poliklinika Karlova Ves - vek od 6 rokov (1)",
      longitude: 17.06124286,
      latitude: 48.15410566,
      city: "Bratislava",
      street_name: "Líščie údolie",
      street_number: "57 - interér",
      postal_code: nil,
      region_id: nil,
      county_id: nil,
      reservations_url: "https://www.old.korona.gov.sk/covid-19-patient-form.php",
      external_id: "289",
      external_endpoint: nil,
      supports_reservation: true,
      enabled: false
    }
  end

  subject(:service) do
    ApplyOverride
      .new(
        record: record,
        override: override,
      )
      .perform
  end

  let(:override) do
    build(
      :override,
      replacements: replacements
    )
  end

  context 'empty replacements' do
    let(:replacements) do
      []
    end

    it 'should do nothing' do
      expect(service).to eq record
    end
  end

  context 'more separate replacements' do
    let(:replacements) do
      [
        { title: 'Foo bar' },
        { street_name: 'Bar baz' },
      ]
    end

    it 'should replace title' do
      expect(service).not_to eq record

      expect(service[:title]).to eq 'Foo bar'
      expect(service[:street_name]).to eq 'Bar baz'
    end
  end

  context 'more combined replacements' do
    let(:replacements) do
      [
        { title: 'Foo bar', street_name: 'Bar baz' },
      ]
    end

    it 'should replace title' do
      expect(service).not_to eq record

      expect(service[:title]).to eq 'Foo bar'
      expect(service[:street_name]).to eq 'Bar baz'
    end
  end

  context 'replacements with ERB' do
    let(:replacements) do
      [
        { title: 'Foo <%= record[:street_name] %> Bar' },
      ]
    end

    it 'should replace title with ERB template' do
      expect(service[:title]).to eq 'Foo Líščie údolie Bar'
    end
  end

  context 'replacements with nil value' do
    let(:replacements) do
      [
        { title: nil },
      ]
    end

    it 'should replace title with ERB template' do
      expect(service[:title]).to be_nil
    end
  end
end
