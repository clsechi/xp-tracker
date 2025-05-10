class JsonWebToken
  SECRET_KEY = Rails.application.credentials.secret_key_base
  EXPIRATION_HOURS = 24

  def self.encode(payload, exp = EXPIRATION_HOURS.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, 'HS512')
  end

  def self.decode(token)
    body = JWT.decode(token, SECRET_KEY)[0]
    result = ActiveSupport::HashWithIndifferentAccess.new(body)

    return nil if result[:exp].to_i < Time.current.to_i

    result
  rescue StandardError
    nil
  end
end
