class Playlist < ApplicationRecord
  belongs_to :user
  validates :spotify_id, presence: true
  after_save :unfollow_later, if: :saved_change_to_schedule_unfollow_at?

  def unfollow!
    if spotify_id
      playlist = RSpotify::Playlist.find_by_id(spotify_id)
      user.spotify_client.unfollow(playlist)
      update(unfollow: true)
    end
  end

  private

  def unfollow_later
    UnfollowPlaylistJob.set(wait_until: schedule_unfollow_at).perform_later(self)
  end
end
