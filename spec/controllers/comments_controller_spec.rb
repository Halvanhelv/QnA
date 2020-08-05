require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe 'POST #create' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer) }
    let(:user) { create(:user) }

    context 'Authenticated user' do
      before { login(user) }

      shared_examples 'comment saves with correct user' do
        it 'comment saves with correct author' do
          subject
          expect(assigns(:comment).user).to eq(user)
        end
      end
      shared_examples 'comment saves with correct author' do
        it 'create comment' do
          expect { subject }.to change(Comment, :count).by(1)
        end
      end

      shared_examples 'render create view' do
        it 'render create view' do
          subject
          expect(response).to render_template :create
        end
      end

      shared_examples 're-render create view' do
        it 're-render create view' do
          subject
          expect(response).to render_template :create
        end
      end

      context 'for question' do
        context 'with correct attributes' do
          subject { post :create, params: { comment: attributes_for(:comment), question_id: question, commentable: 'questions', format: :js } }

          include_examples 'comment saves with correct author'
          include_examples 'render create view'
          include_examples 'comment saves with correct user'

          it 'comment saves with correct question' do
            subject
            expect(assigns(:comment).commentable).to eq(question)
          end

          it 'streaming to channel' do
            expect { subject }.to broadcast_to("question_#{question.id}_comments").with(a_hash_including(author: user.email))
          end
        end

        context 'with invalid attributes' do
          subject { post :create, params: { comment: attributes_for(:comment, :invalid), question_id: question, commentable: 'questions', format: :js } }

          it 'does not save the comment' do
            expect { subject }.to_not change(Comment, :count)
          end

          include_examples 're-render create view'

          it 'do not streaming to channel' do
            expect { subject }.to_not broadcast_to("question_#{question.id}_comments").with(a_hash_including(author: user.email))
          end
        end
      end

      context 'for answer' do
        context 'with correct attributes' do
          subject { post :create, params: { comment: attributes_for(:comment), answer_id: answer, commentable: 'answers', format: :js } }

          include_examples 'comment saves with correct user'
          include_examples 'comment saves with correct author'

          it 'comment saves with correct answer' do
            subject
            expect(assigns(:comment).commentable).to eq(answer)
          end

          it 'streaming to channel' do
            expect { subject }.to_not broadcast_to("answer_#{question.id}_comments").with(a_hash_including(author: user.email))
          end
        end

        context 'with invalid attributes' do
          subject { post :create, params: { comment: attributes_for(:comment, :invalid), answer_id: answer, commentable: 'answers', format: :js } }

          it 'does not save the comment' do
            expect { subject }.to_not change(Comment, :count)
          end

          include_examples 're-render create view'

          it 'do not streaming to channel' do
            expect { subject }.to_not broadcast_to("answer_#{answer.id}_comments").with(a_hash_including(author: user.email))
          end
        end
      end
    end

    context 'As guest' do
      shared_examples 'guest try create comment' do
        it 'does not create the comment for resource' do
          expect { subject }.to_not change(Comment, :count)
        end

        it 'responds with 401' do
          subject
          expect(response).to have_http_status :unauthorized
        end
      end
      context 'question' do
        subject { post :create, params: { comment: attributes_for(:comment), question_id: question, commentable: 'questions', format: :js } }
        include_examples 'guest try create comment'
      end
      context 'answer' do
        subject { post :create, params: { comment: attributes_for(:comment), answer_id: answer, commentable: 'answers', format: :js } }

        include_examples 'guest try create comment'
      end
    end
  end
end
