require 'rails_helper'

RSpec.describe "Api::V1::AlbumsController", type: :request do
  describe "GET #search_by_artist", :vcr do
    it "response should have albums" do
      sign_in_user
      get api_v1_albums_path('06HL4z0CvFAxyc27GXpf02')
      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body).first).to have_key("uri")
    end

    it "responds with a 404 if the artist does not exist", :vcr do
      sign_in_user
      get api_v1_albums_path('0000000000000000000000')
      expect(response).to have_http_status(:not_found)
    end
  end
end
