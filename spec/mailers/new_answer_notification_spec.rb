require 'rails_helper'

RSpec.describe NewAnswerNotificationMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let(:mail) { NewAnswerNotificationMailer.notification_for_user(user, answer) }
  let(:mail_for_owner) { NewAnswerNotificationMailer.notification_for_owner(question.user, answer) }

  describe 'NewAnswerNotificationMailer#notification_for_user' do
    it 'renders the headers' do
      expect(mail.subject).to eq("New #{question.title} answers")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq([Rails.application.credentials[:production][:gmail][:email]])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match("New answer for question: #{question.title}: #{answer.body}")
    end
  end

  describe 'NewAnswerNotificationMailer#notification_for_owner' do
    it 'renders the headers' do
      expect(mail_for_owner.subject).to eq("New answer for your question: #{question.title}: #{answer.body}")
      expect(mail_for_owner.to).to eq([question.user.email])
      expect(mail_for_owner.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail_for_owner.body.encoded).to match("New answer for your question: #{question.title}: #{answer.body}")
    end
  end
end
