# frozen_string_literal: true

require 'sphinx_helper'

RSpec.describe SearchController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let(:service) { double('Services::SphinxSearch') }

  describe 'GET #search' do
    it 'return right data' do
      expect(Services::SphinxSearch).to receive(:new).and_return(service)
      expect(service).to receive(:call)
      get :search, params: { search: { scope: 'all', body: question.body } }
    end

    it 'render search page' do
      get :search, params: { search: { scope: 'all', body: question.body } }
      expect(response).to render_template :search
    end
  end

  describe 'search with empty request' do
    it 'returns empty response' do
      get :search, params: { search: { body: '', scope: 'all' } }
      expect(response.body).to be_empty
    end

    it 'returns success' do
      allow(Services::SphinxSearch).to receive(:new).and_return(service)
      allow(service).to receive(:call)
      get :search, params: { search: { scope: 'all', body: '' } }
      expect(response).to render_template :search
    end
  end
end
