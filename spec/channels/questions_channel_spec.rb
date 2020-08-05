require 'rails_helper'

RSpec.describe QuestionsChannel, type: :channel do
  let(:user) { create(:user) }
  before { stub_connection user_id: user.id }

  it 'subscribes' do
    subscribe
    expect(subscription).to be_confirmed
  end

  it 'check particular stream by name' do
    subscribe
    perform :question

    expect(subscription).to have_stream_from('questions')
  end
end
