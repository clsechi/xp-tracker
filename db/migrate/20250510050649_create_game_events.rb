class CreateGameEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :game_events do |t|
      t.string :game_name
      t.string :type
      t.datetime :occurred_at
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
