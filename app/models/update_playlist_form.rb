class UpdatePlaylistForm
  include ActiveModel::Model

  attr_accessor :unfollow_at, :tracks, :playlist

  def update
    add_tracks_to_spotify_playlist
    update_unfollow_date
    true
  end

  private

  def add_tracks_to_spotify_playlist
    return unless tracks.present?
    spotify_playlist = RSpotify::Playlist.find_by_id(playlist.spotify_id)
    spotify_playlist.add_tracks!(tracks.pluck("uri"))
  end

  def update_unfollow_date
    return unless unfollow_at.present?
    date = unfollow_at.to_datetime
    if !playlist.unfollow && date > Time.now
      playlist.update schedule_unfollow_at: date
    end
  end
end