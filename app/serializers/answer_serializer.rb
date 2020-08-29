class AnswerSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :id, :body, :created_at, :updated_at, :files

  has_many :links
  has_many :comments
  belongs_to :user

  def files
    object.files.map do |file|
      { id: file.id, url: rails_blob_path(file, only_path: true) }
    end
  end
end
