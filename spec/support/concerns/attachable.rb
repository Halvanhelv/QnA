# frozen_string_literal: true

require 'spec_helper'

shared_examples_for 'attachable' do
  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
