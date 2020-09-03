class DailyDigestMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_digest_mailer.digest.subject
  #
  def digest(user)
    @questions = Question.where('created_at > ?', 1.days.ago).map(&:title).join(' ')
    @greeting  = "#{t('Hello')} #{user.email}"

    mail(to: user.email, subject: 'List of new questions per day:')
  end
end
