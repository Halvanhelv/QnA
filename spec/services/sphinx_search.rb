# frozen_string_literal: true

require 'sphinx_helper'
RSpec.describe Services::SphinxSearch do
  let(:question) { create(:question) }
  subject { Services::SphinxSearch.new(body: question.title, scope: 'all') }

  it 'Search by request', js: true, sphinx: true do
    expect(ThinkingSphinx).to receive(:search).with(ThinkingSphinx::Query.escape(question.title)).and_call_original
    subject.call
  end

  it 'return right data', js: true, sphinx: true do
    ThinkingSphinx::Test.run do
      expect(ThinkingSphinx.search(ThinkingSphinx::Query.escape(question.title))).to eq(subject.call)
    end
  end
end
