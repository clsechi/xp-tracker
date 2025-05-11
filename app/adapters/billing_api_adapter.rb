class BillingAPIAdapter
  BILLING_API_KEY = Rails.application.credentials.billing_api_token
  BILLING_BASE_URL = 'https://interviews-accounts.elevateapp.com'.freeze

  def fetch_subscription_status(user_id)
    resp = connection.get("/api/v1/users/#{user_id}/billing")

    parse(resp.body)
  end

  private

  def parse(body)
    JSON.parse(body, object_class: ActiveSupport::HashWithIndifferentAccess)
  end

  def connection
    Faraday.new(url: BILLING_BASE_URL) do |conn|
      conn.request(:json)
      conn.response(:raise_error)
      conn.request(:authorization, 'Bearer', BILLING_API_KEY)
    end
  end
end
