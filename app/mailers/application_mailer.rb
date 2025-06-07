# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  if Rails.application.credentials[Rails.env.to_sym] && Rails.application.credentials[Rails.env.to_sym][:gmail]
    default from: Rails.application.credentials[Rails.env.to_sym][:gmail][:email]
  else
    default from: 'from@example.com' # Default value if not configured
    Rails.logger.warn("ApplicationMailer 'from' address not configured for environment: #{Rails.env}. Using default.")
  end
  layout 'mailer'
end
