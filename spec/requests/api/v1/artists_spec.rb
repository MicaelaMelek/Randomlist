require 'rails_helper'

RSpec.describe "Api::V1::Artists", type: :request do
  describe "GET /api/v1/artists" do
    it "response should have artists", :vcr do
      sign_in_user
      params = { artist: 'Taylor' }
      get api_v1_artists_path, params: params
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).first).to have_key('uri')
    end

    it "return an empty array if the artist does not exist", :vcr do
      sign_in_user
      params = { artist: 'jjjjjkk' }
      get api_v1_artists_path, params: params
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to match_array([])
    end

    it "return a Bad Request is the artist is empty", :vcr do
      sign_in_user
      params = { artist: '' }
      get api_v1_artists_path, params: params
      expect(response).to have_http_status(:bad_request)
    end
  end
end
