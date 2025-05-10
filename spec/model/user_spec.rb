require 'rails_helper'

RSpec.describe(User, type: :model) do
  describe 'validations' do
    let(:user) { build(:user) }

    it 'is valid with a valid email and password' do
      expect(user).to(be_valid)
    end

    it 'is invalid without an email' do
      user.email = nil
      expect(user).not_to(be_valid)
      expect(user.errors[:email]).to(include("can't be blank"))
    end

    it 'is invalid without a password' do
      user.password = nil
      expect(user).not_to(be_valid)
      expect(user.errors[:password]).to(include("can't be blank"))
    end

    it 'is invalid if password lacks complexity' do
      user.password = 'password'
      expect(user).not_to(be_valid)
      expect(user.errors[:password]).to(
        include(
          "must include at least one lowercase letter, one uppercase letter, one digit, and one special character"
        )
      )
    end
  end

  describe 'email normalization' do
    it 'downcases and strips the email' do
      user = create(:user, email: '  TeSt@Example.COM  ')
      expect(user.email).to(eq('test@example.com'))
    end
  end

  describe 'secure password' do
    let(:securepass) { Faker::Internet.password(min_length: 10, mix_case: true, special_characters: true) }

    it 'hashes the password securely' do
      user = create(:user, email: 'user@example.com', password: securepass)
      expect(user.password_digest).not_to(eq(securepass))
    end

    it 'authenticates with the correct password' do
      user = create(:user, email: 'user@example.com', password: securepass)
      expect(user.authenticate(securepass)).to(eq(user))
    end

    it 'does not authenticate with the wrong password' do
      user = create(:user, email: 'user@example.com', password: securepass)
      expect(user.authenticate('wrongpass')).to(be_falsey)
    end
  end
end
