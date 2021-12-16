require 'rails_helper'

RSpec.describe "Playlists", type: :request do
  describe "GET /playlists", inertia: true do
    it "render inertia Index component" do
      user = sign_in_user
      user.playlists.build(spotify_id: '1234').save
      user.playlists.build(spotify_id: '5678').save
      get playlists_path
      expect_inertia.to render_component 'playlists/Index'
      expect_inertia.to include_props({ playlists: Playlist.all })
    end
  end

  describe "GET /playlists/new", inertia: true do
    it "render inertia New component" do
      sign_in_user
      get new_playlist_path
      expect_inertia.to render_component 'playlists/New'
    end
  end

  describe "POST /playlists/create", inertia: true do
    it "create spotify playlist", vcr: { match_requests_on: [:method, :path] } do
      sign_in_user
      params = {"name":"Test RSpec","tracks":[{"id":"4ZtFanR9U6ndgddUvNcjcG","name":"good 4 u","artistName":"Olivia Rodrigo","uri":"spotify:track:4ZtFanR9U6ndgddUvNcjcG","artistId":"1McMsnEElThX1knmY4oliG"}],"albums":["4uUAUqIfSomFTbbjGp3TYp","0PZ7lAru5FDFHuirTkWe9Z","1KVKqWeRuXsJDLTW0VuD29","2uEKn92VSvtSmLvOmpdGNG","4uYGMRwon6fQ2zOJhfr0iC","43zbrwwFHh5e7cmDQomx8Z"],"add_global_top":true,"add_recommendations":true,"schedule_unfollow":false}
      post playlists_path, params: params
      expect(Playlist.last).to be_valid
      expect(Playlist.last).to be_has_attribute(:spotify_id)
      follow_redirect!
      expect_inertia.to render_component 'playlists/Show'
      expect_inertia.to include_props({:flash=>{:message=>"Playlist was successfully created.", :alert=>nil}, :playlist=>{"user_id"=>1, "spotify_id"=>"3CgAncbdZlXdzTP1veEl6v"}})
    end
  end
end
