# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'author_of? compares the owner' do
    assert users(:alice).author_of?(questions(:rails))
    assert_not users(:bob).author_of?(questions(:rails))
  end

  test 'requires email and password' do
    user = User.new
    assert_not user.valid?
    assert_includes user.errors.attribute_names, :email
    assert_includes user.errors.attribute_names, :password
  end

  test 'find_for_oauth delegates to FindForOauth' do
    auth = OmniAuth::AuthHash.new(provider: 'github', uid: '123')
    called = false
    service = Object.new
    service.define_singleton_method(:call) { called = true }

    FindForOauth.stub(:new, ->(arg) { arg == auth ? service : raise('unexpected auth') }) do
      User.find_for_oauth(auth)
    end

    assert called
  end
end
