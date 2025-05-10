require 'rails_helper'

RSpec.describe('API::Users', type: :request) do
  describe 'POST /api/user' do
    context 'with valid params' do
      let(:securepass) { Faker::Internet.password(min_length: 10, mix_case: true, special_characters: true) }
      let(:valid_params) do
        {
          email: 'test@example.com',
          password: securepass
        }
      end

      it 'creates a user and returns 201 Created' do
        post(api_users_path, params: valid_params)

        expect(response).to(have_http_status(:created))
        json = response.parsed_body
        expect(json['user']['email']).to(eq('test@example.com'))
      end
    end

    context 'with invalid params' do
      let(:invalid_params) { { email: '', password: '' } }
      let(:matcher) { ["Password can't be blank", "Email can't be blank"] }

      it 'does not create a user and returns 400 Bad Request' do
        expect do
          post(api_users_path, params: invalid_params)
        end.not_to(change(User, :count))

        expect(response).to(have_http_status(:bad_request))
        json = response.parsed_body
        expect(json['errors']).to(eq(matcher))
        expect(json['errors']).not_to(be_empty)
      end
    end
  end
end
