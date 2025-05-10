# == Schema Information
#
# Table name: users
#
#  id                :bigint           not null, primary key
#  email             :string           not null
#  game_events_count :integer          default(0)
#  password_digest   :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class UserSerializer
  def initialize(user)
    @user = user
  end

  def as_json(*)
    user.as_json(except: %i[password_digest game_events_count]).merge(
      stats
    )
  end

  private

  def stats
    {
      total_games_played: user.game_events_count
    }
  end

  attr_reader :user
end
