require 'rails_helper'

RSpec.describe CommentsChannel, type: :channel do
  let(:user) { create(:user) }
  let(:question) { create :question, user: user }
  let(:answer) { create :answer, question: question, user: user, best: false }

  before { stub_connection user_id: user.id }

  it 'subscribes' do
    subscribe
    perform(:follow, id: question.id)
    expect(subscription).to be_confirmed
  end

  it 'subscribes to a stream when question is provided' do
    subscribe

    perform(:follow, id: question.id)

    expect(subscription).to be_confirmed

    expect(subscription).to have_stream_from("question_#{question.id}_comments")
  end

  it 'unsubscribe' do
    subscribe
    perform(:follow, id: question.id)

    expect(subscription).to be_confirmed

    expect(subscription).to have_stream_from("question_#{question.id}_comments")

    perform :unfollow

    expect(subscription).not_to have_streams
  end
end
