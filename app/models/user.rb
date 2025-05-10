# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#
class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validate :password_complexity

  normalizes :email, with: ->(e) { e.strip.downcase }

  private

  def password_complexity
    return if password.blank?

    return if password.match?(/\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9])/)

    errors.add(
      :password,
      'must include at least one lowercase letter, one uppercase letter, one digit, and one special character'
    )
  end
end
