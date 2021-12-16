class PlaylistsController < ApplicationController
  before_action :set_playlist, only: [:show, :edit, :update, :destroy]

  def index
    render inertia: 'playlists/Index', props: {
      playlists: Playlist.all
    }
  end

  def new
    render inertia: 'playlists/New', props: {}
  end

  def create
    new_playlist_form = NewPlaylistForm.new(new_playlist_form_params.merge(current_user: current_user))

    if new_playlist_form.save
      redirect_to new_playlist_form.playlist, notice: 'Playlist was successfully created.'
    else
      redirect_to new_playlist_path, inertia: { errors: new_playlist_form.errors }, alert: 'Playlist was not created.'
    end
  end

  def edit
    render inertia: 'playlists/Edit', props: {
      playlist: @playlist.as_json
    }
  end

  def update
    update_playlist_from = UpdatePlaylistForm.new(update_playlist_form_params.merge(playlist: @playlist))
    if update_playlist_from.update
      redirect_to playlist_path, notice: 'Playlist was successfully update.'
    else
      redirect_to edit_playlist_path(@playlist), alert: 'Playlist was not update.'
    end
  end

  def show
    render inertia: 'playlists/Show', props: {
      playlist: @playlist.as_json(only: [:spotify_id, :user_id])
    }
  end

  def destroy
    @playlist.destroy
    redirect_to playlist_path, notice: 'Playlist was successfully removed.'
  end
  private

  def set_playlist
    @playlist = Playlist.find(params[:id])
  end

  def new_playlist_form_params
    params.permit(:add_global_top, :add_recommendations, :name, :schedule_unfollow, tracks: [:id, :uri], albums: [])
  end

  def update_playlist_form_params
    params.permit(:unfollow_at, tracks: [:uri])
  end
end
