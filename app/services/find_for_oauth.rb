class FindForOauth
  attr_reader :auth
  def initialize(auth)
    @auth = auth
  end

  def call
    oauth_provider = OauthProvider.where(provider: auth.provider, uid: auth.uid.to_s).first
    return oauth_provider.user if oauth_provider

    email = auth.info[:email]
    user = User.where(email: email).first
    if user
      user.create_oauth_provider(auth)
    else
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.create_oauth_provider(auth)

    end
    user
  end
end
