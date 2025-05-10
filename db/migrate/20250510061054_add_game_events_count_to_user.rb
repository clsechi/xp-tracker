class AddGameEventsCountToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :game_events_count, :integer, default: 0
  end
end
