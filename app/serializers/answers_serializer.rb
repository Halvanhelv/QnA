# frozen_string_literal: true

class AnswersSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at

  belongs_to :user

  def body
    object.plain_body
  end
end
