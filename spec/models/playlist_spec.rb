require 'rails_helper'

RSpec.describe Playlist, :type => :model do
  it "is not valid without spotify_id" do
    expect(Playlist.new).not_to be_valid
  end

  it "is valid with spotify_id" do
    expect(Playlist.new(spotify_id: '12345678')).to be_valid
  end
end