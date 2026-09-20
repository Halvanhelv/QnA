# frozen_string_literal: true

class QuestionsSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :short_title

  has_many :answers
  belongs_to :user

  def body
    object.plain_body
  end

  def short_title
    object.title.truncate(7)
  end
end
