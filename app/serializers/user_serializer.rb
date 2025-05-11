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
    base_attributes
      .merge(stats)
      .merge(subscription_status)
  end

  private

  attr_reader :user

  def base_attributes
    user.as_json(except: %i[password_digest game_events_count])
  end

  def stats
    {
      stats: {
        total_games_played: user.game_events_count
      }
    }
  end

  def subscription_status
    {
      subscription_status: user.subscription_status
    }
  end
end
