# frozen_string_literal: true

class DailyDigestMailerPreview < ActionMailer::Preview
  def digest = DailyDigestMailer.digest(User.first)
end
