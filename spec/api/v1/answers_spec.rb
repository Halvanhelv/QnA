require 'rails_helper'
describe 'Answers API', type: :request do
  let(:headers) do
    { 'ACCEPT' => 'application/json' }
  end

  let(:access_token) { create(:access_token) }
  let(:resource) { Answer }
  let(:question) { create(:question) }

  describe 'GET /api/v1/answers' do
    let(:api_path) { api_v1_question_answers_path(question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }
      let(:answer_response) { json['answers'].first }
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq(2)
      end

      it 'contains user object' do
        expect(answer_response['user']['id']).to eq(answer.user.id)
      end
    end
  end
  describe 'GET /api/v1/answers/:id' do
    let(:answer) { create(:answer, :with_links, :with_files) }
    let!(:comment) { create(:comment, commentable: answer, user: answer.user) }
    let(:answer_response) { json['answer'] }
    let(:api_path) { api_v1_answer_path(answer) }

    before { get api_path, params: { access_token: access_token.token }, headers: headers }

    context 'authorized' do
      it 'returns 200 status' do
        expect(response).to be_successful
      end
      it 'returns only one answer' do
        expect(json.size).to eq(1)
      end

      it_behaves_like 'API resource contains' do
        let(:resource_response) { answer_response }
        let(:resource) { answer.reload } # Долго бился но в API resource contains не видно links у answer(resource), приходится перезагружать объект
        # тот же самый код для question в questions_spec.rb показывает links, без необходимости перезагружать объект, чем это вызвано?
      end
    end
  end

  describe 'POST /api/v1/answers' do
    let(:api_path) { api_v1_question_answers_path(question) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      it_behaves_like 'API Create resource' do
        let(:method) { :post }
        let(:valid_attrs) { { body: 'Test answer body' } }
        let(:invalid_attrs) { { body: '' } }
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:answer) { create(:answer, :with_files, :with_links) }
    let(:api_path) { api_v1_answer_path(answer) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let!(:comment) { create(:comment, commentable: answer, user: answer.user) }
      let(:valid_attrs) { { body: 'Test answer body' } }

      let(:invalid_attrs) { { body: '' } }

      it_behaves_like 'API Update resource' do
        let(:method) { :patch }
      end
    end
  end

  describe 'DELETE /api/v1/answers/:id' do
    let!(:answer) { create(:answer, :with_files, :with_links) }
    let(:api_path) { api_v1_answer_path(answer) }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      it_behaves_like 'API Destroy resource' do
        let(:method) { :delete }
      end
    end
  end
end
