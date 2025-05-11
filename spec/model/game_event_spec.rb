require 'rails_helper'

RSpec.describe(GameEvent, type: :model) do
  let(:user) { create(:user) }
  let(:game_event) { build(:game_event, user: user) }

  describe 'validations' do
    it 'is invalid without a game_name' do
      game_event.game_name = nil
      expect(game_event).not_to(be_valid)
      expect(game_event.errors[:game_name]).to(include("can't be blank"))
    end

    it 'is invalid without an occurred_at' do
      game_event.occurred_at = nil
      expect(game_event).not_to(be_valid)
      expect(game_event.errors[:occurred_at]).to(include("can't be blank"))
    end

    it 'is invalid without a type' do
      game_event.type = nil
      expect(game_event).not_to(be_valid)
      expect(game_event.errors[:type]).to(include("can't be blank"))
    end

    it 'is invalid with a type not in the allowed list' do
      game_event.type = 'INVALID_TYPE'
      expect(game_event).not_to(be_valid)
      expect(game_event.errors[:type]).to(include("is not included in the list"))
    end

    it 'normalizes type to uppercase' do
      game_event.type = 'completed'
      game_event.validate
      expect(game_event.type).to(eq('COMPLETED'))
    end

    it 'is valid with valid attributes' do
      expect(game_event).to(be_valid)
    end
  end

  describe 'counter_cache on user' do
    let!(:user) { create(:user) }

    it 'increments game_events_count on create' do
      expect do
        create(:game_event, user: user)
      end.to(change { user.reload.game_events_count }.by(1))
    end

    it 'decrements game_events_count on destroy' do
      event = create(:game_event, user: user)
      expect(user.reload.game_events_count).to(eq(1))

      expect do
        event.destroy
      end.to(change { user.reload.game_events_count }.by(-1))
    end
  end
end
