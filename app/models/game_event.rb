# == Schema Information
#
# Table name: game_events
#
#  id          :bigint           not null, primary key
#  game_name   :string
#  occurred_at :datetime
#  type        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
# Indexes
#
#  index_game_events_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class GameEvent < ApplicationRecord
  self.inheritance_column = nil

  belongs_to :user

  TYPES = %w[COMPLETED].freeze

  validates :game_name,
            :occurred_at,
            :type,
            presence: true

  validates :type, inclusion: { in: TYPES }

  normalizes :type, with: ->(v) { v.upcase }
end
