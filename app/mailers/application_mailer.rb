# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials[:production][:gmail][:email]
  layout 'mailer'
end
