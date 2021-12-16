class CreatePlaylists < ActiveRecord::Migration[6.0]
  def change
    create_table :playlists do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :spotify_id

      t.timestamps
    end
  end
end
