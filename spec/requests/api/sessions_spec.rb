require 'rails_helper'

RSpec.describe('API::Sessions', type: :request) do
  let(:securepass) { Faker::Internet.password(min_length: 10, mix_case: true, special_characters: true) }
  let(:user) { create(:user, password: securepass) }
  let(:headers) { { 'Content-Type' => 'application/json' } }
  let(:url) { '/api/sessions' }

  describe 'POST /api/sessions' do
    context 'with valid credentials' do
      it 'returns a JWT token' do
        post url, params: { email: user.email, password: securepass }.to_json, headers: headers

        expect(response).to(have_http_status(:ok))
        expect(response.parsed_body).to(include('token'))
      end
    end

    context 'with invalid credentials' do
      it 'returns an unauthorized error' do
        post url, params: { email: user.email, password: 'wrongpassword' }.to_json, headers: headers

        expect(response).to(have_http_status(:unauthorized))
        expect(response.parsed_body).to(include('error' => 'Wrong email or password.'))
      end
    end
  end
end
