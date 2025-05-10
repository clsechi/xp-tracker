FactoryBot.define do
  factory :game_event do
    game_name { Faker::Game.title }
    occurred_at { Time.current }
    type { 'COMPLETED' }
    user
  end
end
