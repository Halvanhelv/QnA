# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:service) { double('Service::DailyDigest') }
  let(:users) { create_list(:user, 3) }
  before do
    allow(Services::DailyDigest).to receive(:new).and_return(service)
  end

  it 'calls Service::DailyDigest#send_digest' do
    expect(service).to receive(:send_digest)
    DailyDigestJob.perform_now
  end

  it 'job is created' do
    ActiveJob::Base.queue_adapter = :test
    expect do
      described_class.perform_later
    end.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end
end
