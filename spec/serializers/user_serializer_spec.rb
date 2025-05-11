require 'rails_helper'

RSpec.describe(UserSerializer, type: :serializer) do
  let(:user) { create(:user) }
  let(:serializer) { UserSerializer.new(user) }
  let(:status) { 'active' }

  before do
    allow_any_instance_of(BillingService).to(
      receive(:subscription_status).with(user.id).and_return(status)
    )
  end

  describe '#as_json' do
    describe 'when subscriptions is active' do
      let(:status) { 'active' }

      it 'returns the correct JSON representation of the user' do
        expected_json = {
          created_at: user.created_at.iso8601(3),
          email: user.email,
          stats: {
            total_games_played: user.game_events_count
          },
          id: user.id,
          subscription_status: 'active',
          updated_at: user.updated_at.iso8601(3)
        }.stringify_keys

        expect(serializer.as_json.stringify_keys).to(eq(expected_json))
      end
    end

    describe 'when subscriptions is expired' do
      let(:status) { 'expired' }

      it 'returns the correct JSON representation of the user' do
        expected_json = {
          created_at: user.created_at.iso8601(3),
          email: user.email,
          stats: {
            total_games_played: user.game_events_count
          },
          id: user.id,
          subscription_status: 'expired',
          updated_at: user.updated_at.iso8601(3)
        }.stringify_keys

        expect(serializer.as_json.stringify_keys).to(eq(expected_json))
      end
    end
  end
end
