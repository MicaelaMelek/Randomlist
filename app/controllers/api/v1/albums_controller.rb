class Api::V1::AlbumsController < ApplicationController
  def index
    albums = RSpotify::Artist.find(params[:artist_id]).albums(album_type: 'album', limit: 50,  country: 'AR')
    render json: albums.uniq(&:name)

    rescue RestClient::NotFound => error
      render json: { error: error.message }, status: :not_found

    rescue RestClient::BadRequest => error
      render json: { error: error.message }, status: :bad_request
  end
end