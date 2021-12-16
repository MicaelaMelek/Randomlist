require 'rails_helper'

RSpec.describe "Api::V1::Tracks", type: :request do
  describe "GET /api/v1/tracks" do
    it "response should have tracks", :vcr do
      sign_in_user
      params = { track: 'Ramones' }
      get api_v1_tracks_path, params: params
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).first).to have_key('uri')
    end

    it "return an empty array if the track does not exist", :vcr do
      sign_in_user
      params = { track: 'jjjjjkk' }
      get api_v1_tracks_path, params: params
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to match_array([])
    end

    it "return a Bad Request is the track is empty", :vcr do
      user = User.create(email: 'test@test.com', password: "password", password_confirmation: "password")
      sign_in user
      params = { track: '' }
      get api_v1_tracks_path, params: params
      expect(response).to have_http_status(:bad_request)
    end
  end
end
