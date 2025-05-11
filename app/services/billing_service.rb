class BillingService
  DEFAULT_STATUS = 'active'.freeze
  CACHE_NAMESPACE = 'billing_service'.freeze

  # Assuming recalculations occur daily at midnight.
  # A better implementation would involve receiving update events from the billing service.
  #
  # Fail gracefully to avoid blocking app access on error
  def subscription_status(user_id)
    Rails.cache.fetch(build_cache_key(user_id), expires_in: cache_expiration.seconds) do
      result = BillingAPIAdapter.new.fetch_subscription_status(user_id)

      result.fetch(:subscription_status)
    end
  rescue StandardError => e
    Rails.logger.error(e.message)
    DEFAULT_STATUS
  end

  private

  def build_cache_key(user_id)
    "#{CACHE_NAMESPACE}:user:#{user_id}:subscription_status"
  end

  def cache_expiration
    (Time.current.end_of_day - Time.current).to_i
  end
end
