class NewPlaylistForm
  include ActiveModel::Model

  GLOBAL_TOP_PLAYLIST_ID = '37i9dQZEVXbMDoHDwVN2tF'

  attr_accessor :name, :tracks, :albums, :add_global_top, :add_recommendations, :schedule_unfollow, :current_user, :spotify_playlist
  attr_reader :playlist

  validates :name, presence: true

  def save
    return unless valid?

    gather_form_tracks
    gather_album_tracks
    gather_tracks_recommendations
    gather_artists_recommendations
    gather_global_top_tracks
    create_spotify_playlist
    add_tracks_to_spotify_playlist
    create_local_playlist
  end

  private

  def tracks_to_add
    @tracks_to_add ||= []
  end

  def gather_form_tracks
    return unless tracks.present?
    tracks_to_add << tracks.pluck("uri")
  end

  def gather_album_tracks
    return unless albums.present?

    tracks_to_add << spotify_albums.map(&:tracks).flatten.map(&:uri)
  end

  def gather_tracks_recommendations
    return unless add_recommendations && tracks.present?

    tracks_to_add << find_recommendations(seed_tracks: tracks.pluck("id"))
  end

  def gather_artists_recommendations
    return unless add_recommendations && albums.present?

    tracks_to_add << find_recommendations(seed_artists: spotify_albums.map(&:artists).flatten.map(&:id).uniq)
  end

  def find_recommendations(**seed_params)
    RSpotify::Recommendations.generate(limit: 15, **seed_params).tracks.map(&:uri)
  end

  def spotify_albums
    @spotify_albums ||= RSpotify::Album.find(albums)
  end

  def gather_global_top_tracks
    return unless add_global_top

    tracks_to_add << RSpotify::Playlist.find_by_id(GLOBAL_TOP_PLAYLIST_ID).tracks(limit: 25).map(&:uri)
  end

  def create_spotify_playlist
    @spotify_playlist = current_user.spotify_client.create_playlist!(name)
  end

  def add_tracks_to_spotify_playlist
    shuffled_tracks.each_slice(100) do |batch|
      spotify_playlist.add_tracks!(batch)
    end
  end

  def shuffled_tracks
    tracks_to_add.flatten.uniq.shuffle
  end

  def create_local_playlist
    @playlist = current_user.playlists.build(spotify_id: spotify_playlist.id, schedule_unfollow_at: calculate_unfollow_date)
    @playlist.save
  end

  def calculate_unfollow_date
    return unless schedule_unfollow.present?
    5.days.from_now
  end
end
