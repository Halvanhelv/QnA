# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_one :reward, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user
  belongs_to :user
  has_many :comments, dependent: :destroy, as: :commentable

  include Linkable
  include Attachable
  include Votable
  include Searchable

  searchable_by :title, :body

  after_create :create_subscription
  after_create_commit :broadcast_to_index
  after_update_commit :broadcast_changes
  after_destroy_commit :broadcast_removal

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :body, :title, presence: true

  def best_answer
    answers.best.first
  end

  def ordered_answers
    answers.reorder(best_answer: :desc, id: :asc)
  end

  def subscribed?(user)
    subscriptions.exists?(user: user)
  end

  def subscription(user)
    subscriptions.find_by(user: user)
  end

  def broadcast_answers
    broadcast_replace_to self, target: 'answers', partial: 'answers/list', locals: { question: self }
  end

  private

  def broadcast_to_index
    broadcast_append_to 'questions', target: 'questions', partial: 'questions/list_item', locals: { question: self }
  end

  def broadcast_changes
    broadcast_replace_to 'questions', target: dom_id_for(:list_item), partial: 'questions/list_item',
                                      locals: { question: self }
    broadcast_replace_to self, target: self, partial: 'questions/question', locals: { question: self }
  end

  def broadcast_removal
    broadcast_remove_to 'questions', target: dom_id_for(:list_item)
    broadcast_remove_to self
  end

  def dom_id_for(prefix)
    ActionView::RecordIdentifier.dom_id(self, prefix)
  end

  def create_subscription
    subscriptions.create(user_id: user_id)
  end
end
