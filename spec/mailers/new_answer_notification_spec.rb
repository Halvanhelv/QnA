require 'rails_helper'

RSpec.describe NewAnswerNotificationMailer, type: :mailer do
  let(:user) { create(:user) }
  let(:mail) { NewAnswerNotificationMailer.notification_for_user(user, answer) }
  let(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question, user: user) }

  it 'renders the headers' do
    expect(mail.subject).to eq("New #{question.title} answers")
    expect(mail.to).to eq([user.email])
    expect(mail.from).to eq(['from@example.com'])
  end

  it 'renders the body' do
    expect(mail.body.encoded).to match("New answer for #{question.title}: #{answer.body}")
  end
end
