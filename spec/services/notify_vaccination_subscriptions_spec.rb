require 'rails_helper'

describe NotifyVaccinationSubscriptions do
  let(:plan_date) do
    create(:vaccination_date)
  end

  let(:region) do
    create(:region)
  end

  let!(:subscription1) do
    create(:vaccination_subscription, channel: 'webpush', user_id: 'user1', region: region)
  end

  let!(:subscription2) do
    create(:vaccination_subscription, channel: 'messenger', user_id: 'user2', region: region)
  end

  let(:county) do
    create(:county, region: region)
  end

  let(:place) do
    create(:vacc, region: region, county: county)
  end

  context 'no latest snapshots' do
    it 'should not send any notifications' do
      Subscription.delete_all

      expect_any_instance_of(DeliverNotifications).not_to receive(:perform)

      NotifyVaccinationSubscriptions.new(latest_snapshots: []).perform
    end
  end

  context 'single latest snapshot' do
    let(:snapshot) do
      create(:vaccination_date_snapshot, place: place, plan_date: plan_date, free_capacity: snapshot_capacity)
    end

    let(:previous_snapshot) do
      create(:vaccination_date_snapshot, place: place, plan_date: plan_date, free_capacity: previous_snapshot_capacity)
    end

    let(:latest_snapshot) do
      create(:latest_vaccination_date_snapshot, place: place, plan_date: plan_date, snapshot: snapshot, previous_snapshot: previous_snapshot)
    end

    context 'latest snapshot with capacity decrease' do
      let(:snapshot_capacity) { 1 }
      let(:previous_snapshot_capacity) { 2 }

      it 'should not send any notifications' do
        expect_any_instance_of(DeliverNotifications).not_to receive(:perform)

        NotifyVaccinationSubscriptions.new(latest_snapshots: [latest_snapshot]).perform
      end
    end

    context 'latest snapshot with same capacity' do
      let(:snapshot_capacity) { 1 }
      let(:previous_snapshot_capacity) { 1 }

      it 'should not send any notifications' do
        expect_any_instance_of(DeliverNotifications).not_to receive(:perform)

        NotifyVaccinationSubscriptions.new(latest_snapshots: [latest_snapshot]).perform
      end
    end

    context 'latest snapshot with capacity increase' do
      let(:snapshot_capacity) { 2 }
      let(:previous_snapshot_capacity) { 1 }

      it 'should send notification' do
        stub_messenger_delivery(user_id: 'user2')
        stub_webpush_delivery(user_ids: %w{user1})

        results = NotifyVaccinationSubscriptions.new(latest_snapshots: [latest_snapshot]).perform

        expect(a_request_for_messenger_delivery(user_id: 'user2')).to have_been_made.once
        expect(a_request_for_webpush_delivery(user_ids: %w{user1})).to have_been_made.once

        expect(results.size).to eq 1

        result = results.first
        expect(result[:region_capacities][:region]).to eq region
        expect(result[:region_capacities][:total_current_free_capacity]).to eq 2
        expect(result[:region_capacities][:total_previous_free_capacity]).to eq 1
        expect(result[:deliveries].size).to eq 2
      end
    end
  end

  context 'single latest snapshots' do
    let(:plan_dates) do
      create_list(:vaccination_date, 5)
    end

    let(:snapshots) do
      snapshot_capacities.map.with_index do |n, i|
        create(:vaccination_date_snapshot, place: place, plan_date: plan_dates[i], free_capacity: n)
      end
    end

    let(:previous_snapshots) do
      previous_snapshot_capacities.map.with_index do |n, i|
        create(:vaccination_date_snapshot, place: place, plan_date: plan_dates[i], free_capacity: n)
      end
    end

    let(:latest_snapshots) do
      plan_dates.map.with_index do |_, i|
        create(:latest_vaccination_date_snapshot, place: place, plan_date: plan_dates[i], snapshot: snapshots[i], previous_snapshot: previous_snapshots[i])
      end
    end

    context 'latest snapshots with capacity increase' do
      let(:snapshot_capacities) { [10, 20, 30, 40, 50] }
      let(:previous_snapshot_capacities) { [0, 10, 30, 35, 50] }

      it 'should send notification' do
        stub_messenger_delivery(user_id: 'user2')
        stub_webpush_delivery(user_ids: %w{user1})

        results = NotifyVaccinationSubscriptions.new(latest_snapshots: latest_snapshots).perform

        expect(a_request_for_messenger_delivery(user_id: 'user2')).to have_been_made.once
        expect(a_request_for_webpush_delivery(user_ids: %w{user1})).to have_been_made.once

        expect(results.size).to eq 1

        result = results.first
        expect(result[:region_capacities][:region]).to eq region
        expect(result[:region_capacities][:capacity_delta]).to eq 25
        expect(result[:region_capacities][:total_current_free_capacity]).to eq 150
        expect(result[:region_capacities][:total_previous_free_capacity]).to eq 125
        expect(result[:deliveries].size).to eq 2
      end
    end
  end
end
