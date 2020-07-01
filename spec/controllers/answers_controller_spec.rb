# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user)     { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer_static) { create(:answer, :static, user: user, question: question) }
  let!(:answer)   { create(:answer, user: user, question: question) }
  let(:user_2)   { create(:user) }

  describe 'POST #create' do
    before { login(user) }

    context 'with valid attributes' do

      it 'Verification of the author of the answer' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(assigns(:answer).user_id).to eq(user.id)
      end

      it 'saves a new answer in the database' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question } }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question } }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }
        expect(response).to render_template 'questions/show'
      end
    end
  end
  describe 'PATCH #update' do
    before { login(user) }

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
      before { patch :update, params: { id: answer_static, answer: attributes_for(:answer, :invalid) } }

      it 'does not change answer' do
        answer_static.reload
        expect(answer_static.body).to eq 'TEXT11'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'GET #edit' do
    before { login(user) }

    it 'renders edit view' do
      get :edit, params: { id: answer }
      expect(response).to render_template :edit
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }
    context 'Correct User try delete ' do
    let!(:answer) { create(:answer, user: user, question: question) }

    it 'deletes the answer' do
      expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1)
    end

    it 'deletes the answer' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to question
    end
    end

    it 'Attempting to delete a answer from a non-current user' do
      login(user_2)
      expect { delete :destroy, params: { id: answer } }.to_not change(Answer, :count)
    end
  end
end
