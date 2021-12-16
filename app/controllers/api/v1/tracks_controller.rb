class Api::V1::TracksController < ApplicationController
  def index
    tracks = RSpotify::Track.search(params[:track])
    render json: tracks.uniq(&:name)

    rescue RestClient::BadRequest => error
      render json: { error: error.message }, status: :bad_request
  end
end
