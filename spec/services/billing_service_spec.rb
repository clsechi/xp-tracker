# spec/services/billing_service_spec.rb
require 'rails_helper'

RSpec.describe(BillingService) do
  let(:user_id) { 42 }
  let(:cache_key) { "billing_service:user:#{user_id}:subscription_status" }
  let(:billing_service) { described_class.new }
  let(:api_response) { { 'subscription_status' => 'active' } }

  before do
    Rails.cache.clear
  end

  describe '#subscription_status' do
    context 'when API call is successful' do
      before do
        allow_any_instance_of(BillingAPIAdapter).to(
          receive(:fetch_subscription_status).with(user_id).and_return(api_response)
        )
      end

      it 'returns the API response' do
        expect(Rails.cache).to(receive(:fetch).with(cache_key, expires_in: kind_of(Integer)).once.and_call_original)

        expect(billing_service.subscription_status(user_id)).to(eq('active'))
      end
    end

    context 'when API call raises an error' do
      before do
        allow_any_instance_of(BillingAPIAdapter).to(
          receive(:fetch_subscription_status).with(user_id).and_raise(Faraday::ConnectionFailed.new('Connection error'))
        )
        allow(Rails.logger).to(receive(:error))
      end

      it 'logs the error and returns "active"' do
        expect(billing_service.subscription_status(user_id)).to(eq('active'))
        expect(Rails.logger).to(have_received(:error).with('Connection error'))
      end
    end
  end
end
