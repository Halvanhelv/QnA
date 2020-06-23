# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { question.answers.create(attributes_for(:answer)) }

  describe 'POST #create' do
    context 'with valid attributes' do
      before { post :create, params: { answer: attributes_for(:answer), question_id: question } }

      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(Answer, :count).by(1)
      end

      it 'assigns the requested answer to @answer' do
        expect(assigns(:answer)).to eq question.answers.last
      end

      it 'redirects to show view' do
        expect(response).to redirect_to answer_path(assigns(:answer))
      end
    end
    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        expect(response).to render_template :new
      end
    end
  end
  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'redirects to updated answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }
        expect(response).to redirect_to answer
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) } }

      it 'does not change answer' do
        answer.reload
        expect(answer.body).to eq 'MyAnswer'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end
  describe 'GET #show' do
    it 'renders show view' do
      get :show, params: { id: question.answers.create(attributes_for(:answer)) }
      expect(response).to render_template :show
    end
  end
  describe 'GET #edit' do
    it 'renders edit view' do
      get :edit, params: { id: question.answers.create(attributes_for(:answer)) }
      expect(response).to render_template :edit
    end
  end

  describe 'DELETE #destroy' do
    let!(:answer) { question.answers.create(attributes_for(:answer)) }
    it 'deletes the answer' do
      expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
    end
    it 'deletes the answer' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to question
    end
  end
end