require 'rails_helper'

describe DeliverNotifications do
  context 'messenger channel' do
    context 'single notification' do
      it 'should call messenger api once' do
        stub_messenger_delivery(user_id: 'user1')

        DeliverNotifications.new(channel: 'messenger', user_ids: %w{user1}, text: 'hello').perform

        expect(a_request_for_messenger_delivery(user_id: 'user1')).to have_been_made.once
      end
    end

    context 'multiple notifications' do
      it 'should call messenger api multiple times' do
        stub_messenger_delivery(user_id: 'user1')
        stub_messenger_delivery(user_id: 'user2')

        DeliverNotifications.new(channel: 'messenger', user_ids: %w{user1 user2}, text: 'hello').perform

        expect(a_request_for_messenger_delivery(user_id: 'user1')).to have_been_made.once
        expect(a_request_for_messenger_delivery(user_id: 'user2')).to have_been_made.once
      end
    end
  end

  context 'webpush channel' do
    context 'single notification' do
      it 'should call webpush api once' do
        stub_webpush_delivery(user_ids: %w{user1})

        DeliverNotifications.new(channel: 'webpush', user_ids: %w{user1}, text: 'hello').perform

        expect(a_request_for_webpush_delivery(user_ids: %w{user1})).to have_been_made.once
      end
    end

    context 'multiple notifications' do
      it 'should call webpush api once with multiple users' do
        stub_webpush_delivery(user_ids: %w{user1 user2})

        DeliverNotifications.new(channel: 'webpush', user_ids: %w{user1 user2}, text: 'hello').perform

        expect(a_request_for_webpush_delivery(user_ids: %w{user1 user2})).to have_been_made.once
      end
    end
  end

  context 'duplicate user_ids' do
    it 'should deliver notification to unique user_ids' do
      stub_webpush_delivery(user_ids: %w{user1})

      DeliverNotifications.new(channel: 'webpush', user_ids: %w{user1 user1}, text: 'hello').perform

      expect(a_request_for_webpush_delivery(user_ids: %w{user1})).to have_been_made.once
    end
  end
end
