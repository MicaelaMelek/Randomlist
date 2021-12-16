class AddUnfollowToPlaylist < ActiveRecord::Migration[6.0]
  def change
    add_column :playlists, :unfollow, :boolean, default: false
  end
end
