class UnfollowPlaylistJob < ApplicationJob
  queue_as :default

  def perform(playlist)
    return if playlist.unfollow?
    return if playlist.schedule_unfollow_at > Time.current

    playlist.unfollow!
  end
end
