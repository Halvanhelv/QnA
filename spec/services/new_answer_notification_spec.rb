# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Services::NewAnswerNotification do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question, user: user) }

  it 'sends email to all question subscribers' do
    question.subscriptions.first.delete # удаляю первого подписчика, поскольку он автор вопроса и тест не пройдент поскольку метод notification_for_user не для автора вопроса а для всех остальных подписчиков
    question.subscribers.each do |subscriber|
      expect(NewAnswerNotificationMailer).to receive(:notification_for_user).with(subscriber, answer).and_call_original
    end
    subject.send_notification(answer)
  end

  it 'sends email to question owner' do
    question.subscribers.each do |subscriber|
      expect(NewAnswerNotificationMailer).to receive(:notification_for_owner).with(subscriber, answer).and_call_original
    end
    subject.send_notification(answer)
  end

  it 'do not send email to unsubscribed users' do
    expect(NewAnswerNotificationMailer).to_not receive(:notification_for_user).with(user, answer).and_call_original
    subject.send_notification(answer)
  end
end
