# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let(:service) { double('Services::NewAnswerNotification') }
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:foreign_users) { create_list(:user, 2) }

  it 'calls Service::DailyDigest#send_notification(answer)' do
    allow(Services::NewAnswerNotification).to receive(:new).and_return(service)
    expect(service).to receive(:send_notification).with(answer)
    NewAnswerNotificationJob.perform_now(answer)
  end

  it 'job is created' do
    question.subscriptions.delete_all
    allow(Services::NewAnswerNotification).to receive(:new).and_return(service)
    expect do
      described_class.perform_later(answer)
    end.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :count).by(1) # ответ 2 поскольку в модели Answer выполнится callback и второй раз в строке 19
  end
end
