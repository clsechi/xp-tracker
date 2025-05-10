class JsonWebToken
  SECRET_KEY = Rails.application.credentials.jwt_secret
  EXPIRATION_HOURS = 24
  ALGORITHM = 'HS256'.freeze

  def self.encode(payload, exp = EXPIRATION_HOURS.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, ALGORITHM)
  end

  def self.decode(token)
    body = JWT.decode(token, SECRET_KEY)[0]
    decoded = ActiveSupport::HashWithIndifferentAccess.new(body)

    return nil if decoded[:exp].to_i < Time.current.to_i

    decoded
  rescue JWT::DecodeError, JWT::ExpiredSignature
    nil
  rescue StandardError => e
    Rails.logger.error(e.message)
    nil
  end
end
