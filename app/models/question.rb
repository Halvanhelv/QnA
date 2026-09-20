# frozen_string_literal: true

class Question < ApplicationRecord
  include Linkable, Attachable, Votable, Searchable, Taggable,
          Listable, Subscribable, Broadcasts

  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :comments, dependent: :destroy, as: :commentable
  has_one :reward, dependent: :destroy
  has_one :acceptance, dependent: :destroy, class_name: 'Answer::Acceptance'
  has_one :accepted_answer, through: :acceptance, source: :answer

  has_rich_text :body
  searchable title: :title, body: :plain_body, tags: :tag_list

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :body, :title, presence: true

  def ordered_answers
    answers.left_joins(:acceptance).reorder(Arel.sql('answer_acceptances.id IS NULL, answers.id ASC'))
  end
end
