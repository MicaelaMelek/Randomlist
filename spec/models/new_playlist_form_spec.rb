require 'rails_helper'

RSpec.describe NewPlaylistForm do
  it "should not create a playlist without name" do
    new_playlist_form = NewPlaylistForm.new(add_global_top: true, add_recommendations: true)
    expect(new_playlist_form).not_to be_valid
  end

  it 'creates the playlist with all the options available', :vcr do
    user = User.create(email: 'test@test.com', password: "password", password_confirmation: "password")
    new_playlist_form = NewPlaylistForm.new(name: "Test RSpec", current_user: user, add_global_top: true, add_recommendations: true, tracks:[{'id' => "4ZtFanR9U6ndgddUvNcjcG", 'uri' => "spotify:track:4ZtFanR9U6ndgddUvNcjcG"}], albums: ["4uUAUqIfSomFTbbjGp3TYp"])
    expected_tracks = %w[spotify:track:50nfwKoDiSYg8zOCREWAm5 spotify:track:1r9xUipOqoNwggBpENDsvJ spotify:track:3E7dfMvvCLUddWissuqMwr spotify:track:7vQbuQcyTflfCIOu3Uzzya spotify:track:0lLdorYw7lVrJydTINhWdI spotify:track:1LAsr8OiF3et5bPZ7o9jsZ spotify:track:1MhXdlCQPnO56T57MfmaRm spotify:track:7FPOTINXrud2gCZVAsMTZc spotify:track:0bYg9bo50gSsH3LtXe2SQn spotify:track:4cluDES4hQEUhmXj6TXkSo spotify:track:5x5JM1BSB6vollcIzDocqT spotify:track:0e2SZBDwY2ods2rkb84nmW spotify:track:1IcR6RlgvDczfvoWJSSY2A spotify:track:3rmo8F54jFF8OgYsqTxm5d spotify:track:38kSyZ90BcMkHc5FfTluXs spotify:track:5dXWFMwD7I7zXsInONVl0H spotify:track:6Im9k8u9iIzKMrmV7BWtlF spotify:track:5KL4iZkCTZyXl7KnHgfVDj spotify:track:7KxhSJOYiqCDclXDBNlFSZ spotify:track:1jOBlsvKhdqjZAlUAia4Qz spotify:track:6oWDkRuzwIak4Z2b0M2qAv spotify:track:4fouWK6XVHhzl78KzQ1UjL spotify:track:1vwCXIAjSkUxvn78Cmz84g spotify:track:5enxwA8aAbwZbf5qCHORXi spotify:track:79cuOz3SPQTuFrp8WgftAu spotify:track:04F42oEuKrRComYJfJuyVR spotify:track:4ZtFanR9U6ndgddUvNcjcG spotify:track:5nU5Y20xKhavEai4qqbHl3 spotify:track:3RdOimLk6CxkaYMYtGTCB9 spotify:track:3S9IvjroLrk0D8hBGOfC1h spotify:track:7rglLriMNBPAyuJOMGwi39 spotify:track:5Z9KJZvQzH6PFmb8SNkxuk spotify:track:20I6sIOMTCkB6w7ryavxtO spotify:track:4yH40E15Nwfcroj5Ofooo7 spotify:track:2azpRNbgwmjSmmQZ5PGJGT spotify:track:5KcYtdjhsQrNNMjJOSAUEz spotify:track:20on25jryn53hWghthWWW3 spotify:track:4i9dEGgLlZdSmR4lPXRYiS spotify:track:235hvG1TA5qebFjijpCmaV spotify:track:1x6NaAEZYYGO95PekFcu5C spotify:track:2mfUa8bLs2s5N4VaqJZ4lZ spotify:track:2Twii5CeqM86JxSrnPgydn spotify:track:2B4GHvToeLTOBB4QLzW3Ni spotify:track:0MWiSBKm8Avs8iDIxcertp spotify:track:6xCNYRfzZtoQRo1xruPmNq spotify:track:50PWlIBU7PlGGwzgN8TiFJ spotify:track:4t0OI7XrODjSkAu3bTPmWj spotify:track:2EjXfH91m7f8HiJN1yQg97 spotify:track:0afhq8XCExXpqazXczTSve spotify:track:2FRnf9qhLbvw8fu4IBXx78 spotify:track:0sm5R6MjXORjLcs1bulN6n spotify:track:2RPNCUaDL2ixoY9wGpoJoQ spotify:track:2Bs4jQEGMycglOfWPBqrVG spotify:track:46IZ0fSY2mpAiktS3KOqds spotify:track:5PjdY0CKGZdEuoNab3yDmX spotify:track:5NvOZCjZaGGGL597exlQWv spotify:track:6KfoDhO4XUWSbnyKjNp9c4 spotify:track:61Qhe2mHSLhUE04QeK4lkD spotify:track:0xqHkO5570zlGpLpCnd4MG spotify:track:6Uj1ctrBOjOas8xZXGqKk4 spotify:track:02MWAaffLxlfxAUY7c5dvx spotify:track:5WuBu7WHqaDAIs5dikGclg spotify:track:3DarAbFujv6eYNliUTyqtz spotify:track:0lizgQ7Qw35od7CYaoMBZb spotify:track:2C8lcuMwQrCdUIiKISCYfE spotify:track:7uoFMmxln0GPXQ0AcCBXRq spotify:track:46HNZY1i7O6jwTA7Slo2PI]
    playlist = double(RSpotify::Playlist, id: 123)
    expect(user.spotify_client).to receive(:create_playlist!).with("Test RSpec").and_return(playlist)
    expect(playlist).to receive(:add_tracks!).with(contain_exactly(*expected_tracks))
    expect(new_playlist_form.save).to eq(true)
  end

  it 'creates the playlist without recommendations', :vcr do
    user = User.create(email: 'test@test.com', password: "password", password_confirmation: "password")
    new_playlist_form = NewPlaylistForm.new(name: "Test RSpec", current_user: user, add_global_top: true, add_recommendations: false, tracks:[{'id' => "4ZtFanR9U6ndgddUvNcjcG", 'uri' => "spotify:track:4ZtFanR9U6ndgddUvNcjcG"}], albums: ["4uUAUqIfSomFTbbjGp3TYp"])
    expected_tracks = %w[spotify:track:1LAsr8OiF3et5bPZ7o9jsZ spotify:track:5Z9KJZvQzH6PFmb8SNkxuk spotify:track:1r9xUipOqoNwggBpENDsvJ spotify:track:5nU5Y20xKhavEai4qqbHl3 spotify:track:2azpRNbgwmjSmmQZ5PGJGT spotify:track:4yH40E15Nwfcroj5Ofooo7 spotify:track:4i9dEGgLlZdSmR4lPXRYiS spotify:track:46HNZY1i7O6jwTA7Slo2PI spotify:track:5enxwA8aAbwZbf5qCHORXi spotify:track:2EjXfH91m7f8HiJN1yQg97 spotify:track:2B4GHvToeLTOBB4QLzW3Ni spotify:track:7uoFMmxln0GPXQ0AcCBXRq spotify:track:6oWDkRuzwIak4Z2b0M2qAv spotify:track:235hvG1TA5qebFjijpCmaV spotify:track:4fouWK6XVHhzl78KzQ1UjL spotify:track:0bYg9bo50gSsH3LtXe2SQn spotify:track:3S9IvjroLrk0D8hBGOfC1h spotify:track:46IZ0fSY2mpAiktS3KOqds spotify:track:3DarAbFujv6eYNliUTyqtz spotify:track:0lLdorYw7lVrJydTINhWdI spotify:track:3rmo8F54jFF8OgYsqTxm5d spotify:track:50nfwKoDiSYg8zOCREWAm5 spotify:track:0lizgQ7Qw35od7CYaoMBZb spotify:track:5dXWFMwD7I7zXsInONVl0H spotify:track:2FRnf9qhLbvw8fu4IBXx78 spotify:track:7rglLriMNBPAyuJOMGwi39 spotify:track:6Uj1ctrBOjOas8xZXGqKk4 spotify:track:5WuBu7WHqaDAIs5dikGclg spotify:track:7vQbuQcyTflfCIOu3Uzzya spotify:track:20on25jryn53hWghthWWW3 spotify:track:1IcR6RlgvDczfvoWJSSY2A spotify:track:2C8lcuMwQrCdUIiKISCYfE spotify:track:4ZtFanR9U6ndgddUvNcjcG spotify:track:02MWAaffLxlfxAUY7c5dvx spotify:track:1vwCXIAjSkUxvn78Cmz84g spotify:track:1x6NaAEZYYGO95PekFcu5C spotify:track:2Twii5CeqM86JxSrnPgydn spotify:track:5PjdY0CKGZdEuoNab3yDmX]
    playlist = double(RSpotify::Playlist, id: 123)
    expect(user.spotify_client).to receive(:create_playlist!).with("Test RSpec").and_return(playlist)
    expect(playlist).to receive(:add_tracks!).with(contain_exactly(*expected_tracks))
    expect(new_playlist_form.save).to eq(true)
  end

  it 'creates the playlist without the top global', :vcr do
    user = User.create(email: 'test@test.com', password: "password", password_confirmation: "password")
    new_playlist_form = NewPlaylistForm.new(name: "Test RSpec", current_user: user, add_global_top: false, add_recommendations: true, tracks:[{'id' => "4ZtFanR9U6ndgddUvNcjcG", 'uri' => "spotify:track:4ZtFanR9U6ndgddUvNcjcG"}], albums: ["4uUAUqIfSomFTbbjGp3TYp"])
    expected_tracks = %w[spotify:track:005lwxGU1tms6HGELIcUv9 spotify:track:5WuBu7WHqaDAIs5dikGclg spotify:track:4Zcz6saEkOII3PlXd9gN3o spotify:track:1rKBOL9kJfX1Y4C3QaOvRH spotify:track:5nU5Y20xKhavEai4qqbHl3 spotify:track:1huvTbEYtgltjQRXzrNKGi spotify:track:4ZtFanR9U6ndgddUvNcjcG spotify:track:2g1KggY9PKvsoEAOaiz4xx spotify:track:5OnclJovQKLu18ip7L9PiC spotify:track:6ZuahEctZD6w75peme58hm spotify:track:2C8lcuMwQrCdUIiKISCYfE spotify:track:1CODAIfeSTMzIgBK0S3H5S spotify:track:6exlZ2feJgEip3oaJ6uuuj spotify:track:59tskctgqUmjCWAwhzYAFm spotify:track:55Am8neGJkdj2ADaM3aw5H spotify:track:14am6hDpnDFy0PILHJ2VX1 spotify:track:2azpRNbgwmjSmmQZ5PGJGT spotify:track:3RBluWmSoG2pGA1OePzGJI spotify:track:0PDUDa38GO8lMxLCRc4lL1 spotify:track:4yH40E15Nwfcroj5Ofooo7 spotify:track:6rbusyA3DqbX30SLn7aofn spotify:track:5pqhl8y5GDxgSpaCgtaIgb spotify:track:2Twii5CeqM86JxSrnPgydn spotify:track:1x6NaAEZYYGO95PekFcu5C spotify:track:2zDt2TfQbxiSPjTVJTgbwz spotify:track:2BgEsaKNfHUdlh97KmvFyo spotify:track:6tS3XVuOyu10897O3ae7bi spotify:track:1yjY7rpaAQvKwpdUliHx0d spotify:track:1Ov37jtRQ2YNAe8HzfczkL spotify:track:0VE4kBnHJUgtMf0dy6DRmW spotify:track:2WnAKZefdRHxtBEkRjFOHC spotify:track:3SZLtkoHoECHHuOnNkNCuS spotify:track:235hvG1TA5qebFjijpCmaV spotify:track:67citk3uzWs5qbaIVKTeg8 spotify:track:6oWDkRuzwIak4Z2b0M2qAv spotify:track:03Nor3UpgNjFpsv4rEQSgr spotify:track:1vwCXIAjSkUxvn78Cmz84g spotify:track:4i9dEGgLlZdSmR4lPXRYiS spotify:track:3S9IvjroLrk0D8hBGOfC1h spotify:track:3XHdk0KVdgO2sRH5dqibFB spotify:track:3xrn9i8zhNZsTtcoWgQEAd spotify:track:1LAsr8OiF3et5bPZ7o9jsZ spotify:track:2kS6td1yvmpNgZTt1q5pQq]
    playlist = double(RSpotify::Playlist, id: 123)
    expect(user.spotify_client).to receive(:create_playlist!).with("Test RSpec").and_return(playlist)
    expect(playlist).to receive(:add_tracks!).with(contain_exactly(*expected_tracks))
    expect(new_playlist_form.save).to eq(true)
  end

  it 'creates the playlist only with tracks', :vcr do
    user = User.create(email: 'test@test.com', password: "password", password_confirmation: "password")
    new_playlist_form = NewPlaylistForm.new(name: "Test RSpec", current_user: user, tracks:[{'id' => "4ZtFanR9U6ndgddUvNcjcG", 'uri' => "spotify:track:4ZtFanR9U6ndgddUvNcjcG"}])
    expected_tracks = %w[spotify:track:4ZtFanR9U6ndgddUvNcjcG]
    playlist = double(RSpotify::Playlist, id: 123)
    expect(user.spotify_client).to receive(:create_playlist!).with('Test RSpec').and_return(playlist)
    expect(playlist).to receive(:add_tracks!).with(contain_exactly(*expected_tracks))
    expect(new_playlist_form.save).to eq(true)
  end

  it 'creates the playlist only with albums', :vcr do
    user = User.create(email: 'test@test.com', password: "password", password_confirmation: "password")
    new_playlist_form = NewPlaylistForm.new(name: "Test RSpec", current_user: user, add_global_top: false, add_recommendations: false, tracks:[], albums: ["4uUAUqIfSomFTbbjGp3TYp"])
    expected_tracks = %w[spotify:track:2C8lcuMwQrCdUIiKISCYfE spotify:track:2azpRNbgwmjSmmQZ5PGJGT spotify:track:2Twii5CeqM86JxSrnPgydn spotify:track:1vwCXIAjSkUxvn78Cmz84g spotify:track:4i9dEGgLlZdSmR4lPXRYiS spotify:track:4yH40E15Nwfcroj5Ofooo7 spotify:track:1x6NaAEZYYGO95PekFcu5C spotify:track:6oWDkRuzwIak4Z2b0M2qAv spotify:track:5nU5Y20xKhavEai4qqbHl3 spotify:track:5WuBu7WHqaDAIs5dikGclg spotify:track:3S9IvjroLrk0D8hBGOfC1h spotify:track:235hvG1TA5qebFjijpCmaV spotify:track:1LAsr8OiF3et5bPZ7o9jsZ]
    playlist = double(RSpotify::Playlist, id: 123)
    expect(user.spotify_client).to receive(:create_playlist!).with('Test RSpec').and_return(playlist)
    expect(playlist).to receive(:add_tracks!).with(contain_exactly(*expected_tracks))
    expect(new_playlist_form.save).to eq(true)
  end
end
