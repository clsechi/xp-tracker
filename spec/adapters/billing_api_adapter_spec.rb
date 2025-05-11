require 'rails_helper'

RSpec.describe(BillingAPIAdapter) do
  let(:user_id) { 123 }
  let(:api_url) { "https://interviews-accounts.elevateapp.com/api/v1/users/#{user_id}/billing" }
  let(:response_body) { { subscription_status: 'active' }.to_json }

  before do
    stub_request(:get, api_url)
      .with(headers: {
              'Authorization' => "Bearer #{Rails.application.credentials.billing_api_token}"
            })
      .to_return(status: 200, body: response_body, headers: { 'Content-Type' => 'application/json' })
  end

  describe '#fetch_subscription_status' do
    it 'returns parsed JSON response' do
      result = described_class.new.fetch_subscription_status(user_id)
      expect(result).to(be_present)
      expect(result[:subscription_status]).to(eq('active'))
    end

    context 'when API returns an error' do
      before do
        stub_request(:get, api_url)
          .to_return(status: 404, body: { error: 'Not Found' }.to_json)
      end

      it 'raises Faraday::ResourceNotFound' do
        expect do
          described_class.new.fetch_subscription_status(user_id)
        end.to(raise_error(Faraday::ResourceNotFound))
      end
    end
  end
end
