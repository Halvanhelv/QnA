require 'rails_helper'

shared_examples_for 'subscribe' do
  describe 'PATCH #subscribe' do
    context 'User authorized' do
      before do
        login(user)
        patch :unsubscribe, params: { id: question, format: :js } # при создании вопроса, колбэк создает подписку и нужно для начала от нее отказаться для проверки работы подписки
      end
      it 'saves a new subscription in the database' do
        expect do
          patch :subscribe, params: { id: question, format: :js }
        end.to change(question.subscriptions, :count).by(1)
      end

      it 'render subscribe view' do
        patch :subscribe, params: { id: question, format: :js }

        expect(response).to render_template :subscribe
      end
    end
    context 'Guest' do
      let!(:subscription) { create(:subscription, user: question.user) }
      it 'try subscribe to question' do
        expect do
          patch :subscribe, params: { id: question, format: :js }
        end.to_not change(question.subscriptions, :count)
      end

      it 'status Code: 401 Unauthorized' do
        patch :subscribe, params: { id: question, format: :js }
        expect(response.status).to eq 401
      end
    end
  end
  describe 'DELETE #unsubscribe' do
    context 'User authorized' do
      before do
        login(user)
      end
      it 'delete a subscription in the database' do
        expect do
          delete :unsubscribe, params: { id: question, format: :js }
        end.to change(question.subscriptions, :count).by(-1)
      end
      it 'render unsubscribe view' do
        delete :unsubscribe, params: { id: question, format: :js }

        expect(response).to render_template :unsubscribe
      end
    end
    context 'Guest' do
      it 'try unsubscribe to question' do
        expect do
          delete :unsubscribe, params: { id: question, format: :js }
        end.to_not change(question.subscriptions, :count)
      end
      it 'status Code: 401 Unauthorized' do
        delete :unsubscribe, params: { id: question, format: :js }
        expect(response.status).to eq 401
      end
    end
  end
end
