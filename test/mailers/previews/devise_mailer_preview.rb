# frozen_string_literal: true

# Browse the mail previews at /rails/mailers in development.
class DeviseMailerPreview < ActionMailer::Preview
  def confirmation_instructions = Devise::Mailer.confirmation_instructions(user, 'preview-token')
  def reset_password_instructions = Devise::Mailer.reset_password_instructions(user, 'preview-token')
  def password_change = Devise::Mailer.password_change(user)
  def email_changed = Devise::Mailer.email_changed(user)
  def unlock_instructions = Devise::Mailer.unlock_instructions(user, 'preview-token')

  private

  def user = User.first || User.new(email: 'someone@example.com')
end
