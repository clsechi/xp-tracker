module API
  class GameEventsController < API::ApplicationController
    before_action :authenticate_user!

    # @route POST /api/user/game_events (api_user_game_events)
    def create
      game_event = @current_user.game_events.build(game_event_params)

      if game_event.save
        render(json: game_event, status: :created)
      else
        render(
          json: { errors: game_event.errors.full_messages },
          status: :bad_request
        )
      end
    end

    private

    def game_event_params
      params.expect(game_event: %i[game_name occurred_at type])
    end
  end
end
