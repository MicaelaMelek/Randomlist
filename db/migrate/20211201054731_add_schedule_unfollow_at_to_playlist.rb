class AddScheduleUnfollowAtToPlaylist < ActiveRecord::Migration[6.0]
  def change
    add_column :playlists, :schedule_unfollow_at, :datetime
  end
end
