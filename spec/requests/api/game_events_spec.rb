require 'rails_helper'

RSpec.describe('GameEvents', type: :request) do
  let(:user) { create(:user) }
  let(:payload) { { user_id: user.id } }
  let(:token) { JsonWebToken.encode(payload) }
  let(:headers) { { Authorization: token } }

  describe 'POST /game_events' do
    describe 'when valid params' do
      let(:valid_params) do
        {
          game_event: {
            game_name: 'Tetris',
            occurred_at: Time.current,
            type: 'COMPLETED'
          }
        }
      end

      it 'creates a new game event with valid params' do
        post api_user_game_events_path, params: valid_params, headers: headers

        expect(response).to(have_http_status(:created))
        expect(response.parsed_body['game_name']).to(eq('Tetris'))
        expect(user.game_events.count).to(eq(1))
      end
    end

    describe 'when invalid params' do
      let(:invalid_params) do
        {
          game_event: {
            game_name: '',
            type: 'INVALID'
          }
        }
      end

      it 'returns errors with invalid params' do
        post api_user_game_events_path, params: invalid_params, headers: headers

        expect(response).to(have_http_status(:bad_request))
        expect(response.parsed_body['errors']).to(
          include(
            "Game name can't be blank",
            "Type is not included in the list",
            "Occurred at can't be blank"
          )
        )
      end
    end

    describe 'with a invalid token' do
      let(:token) { 'invalid' }

      it 'returns unauthorized' do
        get api_users_path, headers: headers

        expect(response).to(have_http_status(:unauthorized))
      end
    end
  end
end
