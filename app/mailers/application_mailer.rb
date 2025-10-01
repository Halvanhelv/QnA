# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.dig(Rails.env.to_sym, :gmail, :email) || 'from@example.com'
  layout 'mailer'
end
