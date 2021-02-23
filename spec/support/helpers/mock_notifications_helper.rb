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
    stub_request(:post, 'https://www.googleapis.com/oauth2/v4/token')
      .to_return(
        headers: {
          'Content-Type': 'application/json',
        },
        body: {
          'access_token' => 'token',
          'expires_in' => 120,
        }.to_json
      )

    stub_request(:post, 'https://fcm.googleapis.com/batch')
      .with do |request|
      request.body
        .split.grep(/\A{/)
        .map do |payload|
        JSON.parse(payload)
      end
        .all? do |json|
        token = json.dig('message', 'token')
        user_ids.include?(token)
      end
    end
      .to_return(status: status)
  end

  def a_request_for_webpush_delivery(user_ids:)
    a_request(:post, 'https://fcm.googleapis.com/batch')
      .with do |request|
      request.body
        .split.grep(/\A{/)
        .map do |payload|
        JSON.parse(payload)
      end
        .any? do |json|
        token = json.dig('message', 'token')
        user_ids.include?(token)
      end
    end
  end
end