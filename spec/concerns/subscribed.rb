require 'rails_helper'

shared_examples_for 'subscribed' do
  describe 'PATCH #subscribe' do
    context 'User authorized' do
      before do
        login(user)
        patch :unsubscribe, params: { id: question, format: :json } # при создании вопроса, колбэк создает подписку и нужно для начала от нее отказаться для проверки работы подписки
      end
      it 'saves a new subscription in the database' do
        expect do
          patch :subscribe, params: { id: question, format: :json }
        end.to change(question.subscriptions, :count).by(1)
      end

      # it 'render create view' do
      #   post :subscribe, params: { id: question, format: :js }
      #
      #   expect(response).to render_template :create
      # end
    end
    context 'Guest' do
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
          delete :unsubscribe, params: { id: question, format: :json }
        end.to change(question.subscriptions, :count).by(-1)
      end
      # it 'render destroy view' do
      #   delete :unsubscribe, params: { id: question, format: :js }
      #
      #   expect(response).to render_template :destroy
      # end
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
