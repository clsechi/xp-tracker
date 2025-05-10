module API
  class ApplicationController < ActionController::API
    include API::ErrorHandler

    before_action :authenticate_user!

    def self.allow_unauthenticated_access(**)
      skip_before_action(:authenticate_user!, **)
    end

    private

    def authenticate_user!
      header = request.headers['Authorization']
      return render_unauthorized if header.blank?

      token = header.split.last
      decoded = JsonWebToken.decode(token)
      @current_user = User.find_by(id: decoded[:user_id]) if decoded

      render_unauthorized unless @current_user
    end

    def render_unauthorized
      render(json: { error: 'Unauthorized' }, status: :unauthorized)
    end

    def render_too_many_requests
      render(json: { message: 'Try again later.' }, stauts: :too_many_requests)
    end
  end
end
