# frozen_string_literal: true

class FindForOauth
  attr_reader :auth
  def initialize(auth)
    @auth = auth
  end

  def call
    oauth_provider = OauthProvider.where(provider: auth['provider'], uid: auth['uid'].to_s).first
    return oauth_provider.user if oauth_provider

    email = auth['info']['email'] if auth['info'] && auth['info']['email']
    email_from_user = auth['info']['mail_from_user'] if auth['info'] && auth['info']['mail_from_user']
    user = User.where(email: email).first
    if user
      user.create_oauth_provider(auth)
    elsif email
      user = User.create(email: email, password: pass_generate, password_confirmation: pass_generate, confirmed_at: Time.now)
      user.create_oauth_provider(auth)
    else
      user = User.create(email: email_from_user, password: pass_generate, password_confirmation: pass_generate)
      user.create_oauth_provider(auth)
    end
    user
  end

  private

  def pass_generate
    @pass_generate ||= Devise.friendly_token[0, 20]
  end
end
