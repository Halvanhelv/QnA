# frozen_string_literal: true

require 'rails_helper'
RSpec.describe QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }

  let(:user_2) { create(:user) }
  let(:questions) { create_list(:question, 3, user: user) }

  describe 'GET #index' do
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question } }

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { login(user) } # method from the module in the support folder for automatic authorization in the test

    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    context 'User is authorized' do
      before { login(user) }

      context 'with valid attributes' do

        subject { post :create, params: { question: attributes_for(:question) } }

        it 'Verification of the author of the question' do
          subject
          expect(assigns(:question).user_id).to eq(user.id)
        end

        it 'saves a new question in the database' do
          expect {   subject }.to change(Question, :count).by(1)
        end

        it 'redirects to show view' do
          post :create, params: { question: attributes_for(:question) }
          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do

        subject { post :create, params: { question: attributes_for(:question, :invalid) } }

        it 'does not save the question' do
          expect { subject }.not_to change(Question, :count)
        end

        it 're-renders new view' do
          subject
          expect(response).to render_template :new
        end
      end
    end

    context 'User not authorized' do
      it 'redirects to sign_in page' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH #update' do
    before { login(user) }

    context 'with valid attributes' do

      subject { patch :update, params: { id: question, question: attributes_for(:question), format: :js } }

      it 'assigns the requested question to @question' do
        subject
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, params: { id: question, question: { title: 'new title', body: 'new body' }, format: :js }
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to updated question' do
        subject
        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) }, format: :js }

      it 'does not change question' do
        question.reload
        expect(question.title).to eq question.title
        expect(question.body).to eq question.body
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    context 'delete question from author' do

      subject { delete :destroy, params: { id: question } }

      it 'deletes the question' do
        expect { subject }.to change(Question, :count).by(-1)
      end

      it 'redirects to index' do
        subject
        expect(response).to redirect_to questions_path
      end
    end

    context 'Delete another author’s question' do
      it 'Trying to delete question' do
        login(user_2)
        expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)
      end
    end
  end
end
