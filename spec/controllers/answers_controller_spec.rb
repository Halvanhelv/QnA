require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  describe 'POST #create' do

    before { post :create, params: { answer: attributes_for(:answer), question_id: question } }

    it 'saves a new answer in the database' do
      expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(Answer, :count).by(1)
    end

    it 'assigns the requested answer to @answer' do
      expect(assigns(:answer)).to eq question.answers.last
    end

    it 'redirects to show view' do
      expect(response).to redirect_to question_answer_path(question, assigns(:answer))
    end
  end
end
