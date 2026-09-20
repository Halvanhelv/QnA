# frozen_string_literal: true

require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include Devise::Test::IntegrationHelpers

  Capybara.default_max_wait_time = 5
  Capybara.enable_aria_label = true

  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]

  # The :test cable adapter never delivers messages; system tests need real Turbo Stream delivery.
  setup do
    @original_cable_config = ActionCable.server.config.cable
    ActionCable.server.config.cable = { 'adapter' => 'async' }
    ActionCable.server.restart
  end

  teardown do
    ActionCable.server.config.cable = @original_cable_config
    ActionCable.server.restart
  end

  # Lexxy renders a contenteditable instead of a textarea
  def fill_in_editor(text, within: nil)
    scope = within ? find(within) : page
    editor = scope.find('lexxy-editor [contenteditable]', match: :first)
    editor.click
    editor.send_keys(text)
  end

  def sign_in_through_form(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user_password
    click_button 'Log in'
    assert_text 'Signed in successfully'
  end
end
