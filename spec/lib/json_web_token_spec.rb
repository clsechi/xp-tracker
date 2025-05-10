require 'rails_helper'

RSpec.describe(JsonWebToken, type: :lib) do
  let(:payload) { { user_id: 1, name: 'Test User' } }
  let(:expiration_time) { 24.hours.from_now }
  let(:token) { JsonWebToken.encode(payload, expiration_time) }

  describe '.encode' do
    it 'encodes a payload into a JWT token' do
      encoded_token = JsonWebToken.encode(payload)

      decoded = JWT.decode(encoded_token, JsonWebToken::SECRET_KEY)[0]
      expect(decoded['user_id']).to(eq(payload[:user_id]))
      expect(decoded['name']).to(eq(payload[:name]))
    end

    it 'sets the expiration time correctly' do
      decoded_token = JWT.decode(token, JsonWebToken::SECRET_KEY)[0]
      expect(decoded_token['exp']).to(be > Time.current.to_i)
    end
  end

  describe '.decode' do
    it 'decodes a valid token' do
      decoded_token = JsonWebToken.decode(token)

      expect(decoded_token[:user_id]).to(eq(payload[:user_id]))
      expect(decoded_token[:name]).to(eq(payload[:name]))
    end

    it 'returns nil for an invalid token' do
      invalid_token = 'invalid.token.string'
      decoded_token = JsonWebToken.decode(invalid_token)

      expect(decoded_token).to(be_nil)
    end

    it 'returns nil for an expired token' do
      expired_token = JsonWebToken.encode(payload, 1.hour.ago)
      decoded_token = JsonWebToken.decode(expired_token)

      expect(decoded_token).to(be_nil)
    end

    it 'logs error for unexpected exceptions' do
      allow(Rails.logger).to(receive(:error))
      allow(JWT).to(receive(:decode).and_raise(StandardError, 'Something went wrong'))

      expect(Rails.logger).to(receive(:error).with(/Something went wrong/))
      decoded_token = JsonWebToken.decode(token)

      expect(decoded_token).to(be_nil)
    end
  end
end
