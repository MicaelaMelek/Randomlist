class User < ApplicationRecord
  has_many :playlists, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, :omniauth_providers => [:spotify]

  def self.from_omniauth(auth)
    user = User.where(email: auth.info.email).first
    user ||= User.create!(provider: auth.provider, uid: auth.uid, email: auth.info.email, password: Devise.friendly_token[0, 20])
    user.update(token: auth.credentials.token, refresh_token:auth.credentials.refresh_token)
    user
  end

  def spotify_client
    @spotify_client ||= RSpotify::User.new(
      {
        'credentials' => {
          "token" => token,
          "refresh_token" => refresh_token
        },
        'id' => uid
      })
  end
end
