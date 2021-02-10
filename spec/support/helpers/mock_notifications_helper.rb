module MockNotificationsHelper
  def stub_messenger_delivery(user_id:, status: 200)
    stub_request(:post, %r{https://graph.facebook.com/v3.2/me/messages.*})
      .with(
        body: hash_including(
          recipient: {
            id: user_id,
          },
          messaging_type: 'UPDATE',
        )
      )
      .to_return(status: status)
  end

  def a_request_for_messenger_delivery(user_id:)
    a_request(:post, %r{https://graph.facebook.com/v3.2/me/messages.*})
      .with(
        body: hash_including(
          recipient: {
            id: user_id,
          },
          messaging_type: 'UPDATE',
        )
      )
  end

  def stub_webpush_delivery(user_ids:, status: 200)
    stub_request(:post, 'https://fcm.googleapis.com/fcm/send')
      .with(
        body: hash_including(
          registration_ids: user_ids,
        )
      )
      .to_return(status: status)
  end

  def a_request_for_webpush_delivery(user_ids:)
    a_request(:post, 'https://fcm.googleapis.com/fcm/send')
      .with(
        body: hash_including(
          registration_ids: user_ids,
        )
      )
  end
end