require 'rails_helper'

RSpec.describe(UserSerializer, type: :serializer) do
  let(:user) { create(:user) }
  let(:serializer) { UserSerializer.new(user) }

  describe '#as_json' do
    it 'returns the correct JSON representation of the user' do
      expected_json = {
        created_at: user.created_at.iso8601(3),
        email: user.email,
        total_games_played: user.game_events_count,
        id: user.id,
        updated_at: user.updated_at.iso8601(3)
      }.stringify_keys

      expect(serializer.as_json.stringify_keys).to(eq(expected_json))
    end
  end
end
