# frozen_string_literal: true

class DailyDigestMailer < ApplicationMailer
  def digest(user)
    @questions = Question.recent.with_details.reorder(id: :desc).to_a
    @greeting = "#{t('Hello')} #{user.email}"

    mail(to: user.email, subject: 'List of new questions per day:')
  end
end
