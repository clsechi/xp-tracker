module API
  class UsersController < API::ApplicationController
    allow_unauthenticated_access only: %i[create]

    # @route GET /api/user (api_users)
    def index
      render(
        json: {
          user: UserSerializer.new(@current_user).as_json
        },
        status: :ok
      )
    end

    # @route POST /api/user (api_users)
    def create
      user = User.new(email: params[:email], password: params[:password])

      if user.save
        render(json: { user: UserSerializer.new(user).as_json }, status: :created)
      else
        render(json: { errors: user.errors.full_messages }, status: :bad_request)
      end
    end
  end
end
