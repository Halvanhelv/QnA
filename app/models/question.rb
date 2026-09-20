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
  include Taggable

  has_rich_text :body
  searchable_by :title, rich_text: :body

  after_create :create_subscription
  after_create_commit :broadcast_to_index
  after_update_commit :broadcast_changes
  after_destroy_commit :broadcast_removal

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :body, :title, presence: true

  SORTS = %w[newest unanswered top].freeze
  PER_PAGE = 15

  scope :with_details, -> { includes(:user, :tags).with_rich_text_body }

  # Question list: filtered by tag, ordered by `sort` (newest, unanswered or top)
  def self.listing(sort: 'newest', tag: nil)
    questions = with_details
    questions = questions.tagged_with(tag) if tag.present?

    case sort
    when 'unanswered'
      questions.where.missing(:answers).reorder(id: :desc)
    when 'top'
      rating = "(SELECT COALESCE(SUM(score), 0) FROM votes WHERE votable_type = 'Question' AND votable_id = questions.id)"
      questions.reorder(Arel.sql("#{rating} DESC, questions.id DESC"))
    else
      questions.reorder(id: :desc)
    end
  end

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
    broadcast_prepend_to 'questions', target: 'questions', partial: 'questions/list_item', locals: { question: self }
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
