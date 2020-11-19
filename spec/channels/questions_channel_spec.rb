# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QuestionsChannel, type: :channel do
  let(:user) { create(:user) }
  before { stub_connection user_id: user.id }

  it 'subscribes' do
    subscribe

    perform :follow

    expect(subscription).to be_confirmed
  end

  it 'check particular stream by name' do
    subscribe

    perform :follow

    expect(subscription).to have_stream_from('questions')
  end

  it 'unsubscribe' do
    subscribe
    perform :follow

    expect(subscription).to be_confirmed

    expect(subscription).to have_stream_from('questions')

    perform :unfollow

    expect(subscription).not_to have_streams
  end
end
