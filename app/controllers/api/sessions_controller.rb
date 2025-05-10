module API
  class SessionsController < API::ApplicationController
    allow_unauthenticated_access only: %i[create]

    skip_before_action :authenticate_user!, only: %i[create]

    rate_limit to: 10, within: 3.minutes, only: :create, with: -> { render_too_many_requests }

    # @route POST /api/sessions (api_sessions)
    def create
      if (user = User.authenticate_by(params.permit(:email, :password)))
        token = JsonWebToken.encode(build_token_payload(user))
        render(json: { token: token }, status: :ok)
      else
        render(json: { error: 'Wrong email or password.' }, status: :unauthorized)
      end
    end

    private

    def build_token_payload(user)
      { user_id: user.id }
    end
  end
end
