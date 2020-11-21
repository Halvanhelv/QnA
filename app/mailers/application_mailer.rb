# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials[Rails.env.to_sym][:gmail][:email]
  layout 'mailer'
end
