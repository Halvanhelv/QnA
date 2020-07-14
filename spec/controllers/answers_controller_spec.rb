# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user)          { create(:user) }
  let(:question)      { create(:question) }
  let!(:answer) { create(:answer) }
  let(:user_2)        { create(:user) }
  let(:answer_3)      { create(:answer) }

  describe 'POST #create' do

    context 'User is authorized' do

      subject { post :create, params: { question_id: question, answer: answer_params, format: :js } }

      before { login(user) }

      context 'with valid attributes' do

        let(:answer_params) { attributes_for(:answer) }

        it 'Verification of the author of the answer' do
          subject
          expect(assigns(:answer).user_id).to eq(user.id)
        end

        it 'saves a new answer in the database' do
          expect { subject }.to change(question.answers, :count).by(1)
        end

        # it 'redirects to show view' do
        #   post :create, params: { answer: attributes_for(:answer), question_id: question }
        #   expect(response).to redirect_to question_path(assigns(:question))
        # end
      end

      context 'with invalid attributes' do

        subject { post :create, params: { answer: attributes_for(:answer, :invalid), question_id: question }, format: :js }

        it 'does not save the answer' do
          expect { subject }.not_to change(Answer, :count)
        end

        it 're-renders new view' do
          subject
          expect(response).to render_template :create
        end
      end
    end

    context 'User not authorized' do
      it 'Redirect to sign_in_page' do
        post :create, params: { answer: attributes_for(:answer), question_id: question }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    let!(:answer) { create(:answer, question: question, user: user) }

    context 'with valid attributes' do

      subject { patch :update, params: { id: answer, answer: { body: 'new body' }, format: :js } }

      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer), format: :js }
        expect(assigns(:answer)).to eq answer
      end

      it 'changes answer attributes' do
        subject
        expect(answer.reload.body).to eq 'new body'
      end

      it 'renders to update view' do
        subject
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      let(:answer_static) { create(:answer, body: 'Answer_body_text') }

      before { patch :update, params: { id: answer_static, answer: attributes_for(:answer, :invalid), format: :js } }

      it 'does not change answer' do
        answer_static.reload
        expect(answer_static.body).to eq 'Answer_body_text'
      end

      it 'renders to update view' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do

    before { login(user) }

    subject { delete :destroy, params: { id: answer }, format: :js }

    context 'Correct User try delete ' do
      let!(:answer) { create(:answer, user: user, question: question) }

      it 'deletes the answer' do
        expect { subject }.to change(Answer, :count).by(-1)
      end
    end

    it 'Attempting to delete a answer from a non-current user' do
      login(user_2)
      expect { subject }.not_to change(Answer, :count)
    end
  end

  describe '#PATCH choose_as_best' do
    let!(:question) { create(:question, user: user) }

    context 'Question author' do
      before { login(user) }
      let(:answer) { create(:answer, user: user, question: question) }

      context 'best answer not yet' do
        it 'try choose best answer' do
          patch :best_answer, params: { id: answer, format: :js }
          expect(question.reload.answers.best.first).to eq(answer)
        end
      end

      context 'best answer already exist' do
        let!(:answer) { create(:answer, question: question, best_answer: true) }
        let!(:another_answer) { create(:answer, question: question) }

        before { patch :best_answer, params: { id: another_answer, format: :js } }

        it { expect(response).to render_template(:best_answer) }

        it 'try change best answer' do
          expect(question.reload.best_answer).to eq(another_answer)
        end
      end
    end

    context 'No question author' do
      before { login(user) }
      before { patch :best_answer, params: { id: answer, format: :js } }

      it 'try choose best answer' do
        expect(answer.question.best_answer).to be_nil
      end
    end

    context 'Unauthenticated user' do
      before { patch :best_answer, params: { id: answer, format: :js } }

      it 'try choose best answer' do
        expect(answer.question.best_answer).to be_nil
      end
    end
  end
end
