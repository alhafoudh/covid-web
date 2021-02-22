require 'rails_helper'

describe MatchOverrides do
  subject(:service) do
    MatchOverrides
      .new(
        record: record,
        overrides: overrides,
      )
      .perform
  end

  context 'no overrides' do
    let(:record) do
      attributes_for(:nczi_mom)
    end

    let(:overrides) do
      []
    end

    it 'should not match any override' do
      expect(service).to be_empty
    end
  end

  context 'not matching overrides' do
    let(:record) do
      attributes_for(
        :nczi_mom,
        title: 'Foo bar'
      )
    end

    let(:override) do
      create(
        :place_override,
        matches: [
          {
            title: 'Baz .*',
          }
        ]
      )
    end

    let(:overrides) do
      [
        override,
      ]
    end

    it 'should not match any overrides' do
      expect(service).to be_empty
    end
  end

  context 'matching overrides' do
    let(:record) do
      attributes_for(
        :nczi_mom,
        title: 'Foo bar',
        street_name: 'Bar baz',
      )
    end

    let(:overrides) do
      [
        override,
      ]
    end

    context 'single match' do
      let(:override) do
        create(
          :place_override,
          matches: [
            {
              title: 'Foo .*',
            }
          ]
        )
      end

      it 'should match override' do
        expect(service).to eq [override]
      end
    end

    context 'multiple matches' do
      context 'with multiple matching attribute conditions' do
        let(:override) do
          create(
            :place_override,
            matches: [
              {
                title: 'Foo .*',
                street_name: '.* baz',
              }
            ]
          )
        end

        it 'should match override' do
          expect(service).to eq [override]
        end
      end

      context 'with multiple non-matching attribute conditions' do
        let(:record) do
          create(
            :nczi_mom,
            title: 'Foo bar',
            street_name: 'Abc',
          )
        end

        let(:override) do
          create(
            :place_override,
            matches: [
              {
                title: 'Foo .*',
                street_name: '.* baz',
              }
            ]
          )
        end

        it 'should not match override' do
          expect(service).to be_empty
        end
      end
    end

    context 'number match' do
      let(:record) do
        attributes_for(
          :nczi_mom,
          street_number: 10,
        )
      end

      let(:override) do
        create(
          :place_override,
          matches: [
            {
              street_number: 10,
            }
          ]
        )
      end

      it 'should match override' do
        expect(service).to eq [override]
      end
    end
  end
end