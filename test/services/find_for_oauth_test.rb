# frozen_string_literal: true

require 'test_helper'

class FindForOauthTest < ActiveSupport::TestCase
  def auth(email: nil, mail_from_user: nil, uid: '123')
    info = { email: email, mail_from_user: mail_from_user }.compact
    OmniAuth::AuthHash.new(provider: 'github', uid: uid, info: info)
  end

  test 'returns the user of an existing provider' do
    users(:alice).oauth_providers.create!(provider: 'github', uid: '123')
    assert_equal users(:alice), FindForOauth.new(auth).call
  end

  test 'creates a confirmed user when the provider gives an email' do
    assert_difference -> { User.count } => 1, -> { OauthProvider.count } => 1 do
      user = FindForOauth.new(auth(email: 'new@example.com')).call
      assert user.confirmed?
    end
  end

  test 'creates an unconfirmed user when the email comes from the user' do
    user = FindForOauth.new(auth(mail_from_user: 'typed@example.com')).call
    assert user.persisted?
    assert_not user.confirmed?
  end
end
