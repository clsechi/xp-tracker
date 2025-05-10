module API
  class UsersController < API::ApplicationController
    allow_unauthenticated_access only: %i[create]

    # @route POST /api/user (api_users)
    def create
      user = User.new(email: params[:email], password: params[:password])

      if user.save
        render(json: { user: user }, status: :created)
      else
        render(json: { errors: user.errors.full_messages }, status: :bad_request)
      end
    end
  end
end
