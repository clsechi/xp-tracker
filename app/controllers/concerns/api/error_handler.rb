module API
  module ErrorHandler
    extend ActiveSupport::Concern

    included do
      rescue_from StandardError, with: :handle_generic_error
      rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
    end

    private

    def handle_not_found
      render(json: { error: 'Resource not found' }, status: :not_found)
    end

    def handle_generic_error(error)
      Rails.logger.error("[ERROR][#{error.class.name}] #{error.message}")
      Rails.logger.error("[BACKTRACE] #{error.backtrace.join("\n")}") if error.backtrace.present?

      render(json: { error: 'Something went wrong', details: error.message }, status: :internal_server_error)
    end
  end
end
