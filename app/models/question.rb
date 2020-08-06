# frozen_string_literal: true

class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_one :reward, dependent: :destroy

  after_save :publish_comment

  belongs_to :user
  has_many :comments, dependent: :destroy, as: :commentable

  include Linkable
  include Attachable
  include Votable

  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :body, :title, presence: true

  def best_answer
    answers.best.first
  end

  private

  def publish_comment
    ActionCable.server.broadcast('questions',
                                 id: id,
                                 title: title)
  end
end
