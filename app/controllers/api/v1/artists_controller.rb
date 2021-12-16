class Api::V1::ArtistsController < ApplicationController
  def index
    artists = RSpotify::Artist.search(params[:artist])
    render json: artists

    rescue RestClient::BadRequest => error
      render json: { error: error.message }, status: :bad_request
  end
end
