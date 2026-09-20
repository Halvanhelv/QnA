# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  include Searchable

  searchable_by :body

  validates :body, presence: true, length: { minimum: 10 }

  default_scope { order(:created_at) }

  after_create_commit :broadcast_creation

  def question
    commentable.is_a?(Question) ? commentable : commentable.question
  end

  private

  def broadcast_creation
    broadcast_append_to question, target: ActionView::RecordIdentifier.dom_id(commentable, :comments),
                                  partial: 'comments/comment', locals: { comment: self }
  end
end
