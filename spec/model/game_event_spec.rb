require 'rails_helper'

RSpec.describe(GameEvent, type: :model) do
  let(:user) { create(:user) }
  let(:game_event) { build(:game_event, user: user) }

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
