# frozen_string_literal: true

class Tag < ApplicationRecord
  NAME_FORMAT = /\A[a-z0-9][a-z0-9.+#-]*\z/
  MAX_LENGTH = 30

  has_many :taggings, dependent: :destroy
  has_many :questions, through: :taggings

  validates :name, presence: true, uniqueness: true, length: { maximum: MAX_LENGTH }, format: { with: NAME_FORMAT }

  scope :popular, ->(limit = 10) { where('taggings_count > 0').reorder(taggings_count: :desc, name: :asc).limit(limit) }

  # "Rails, hotwire  ruby" -> ["rails", "hotwire", "ruby"]
  def self.normalize(list)
    list.to_s.downcase.split(/[\s,]+/).map(&:strip).reject(&:blank?).uniq
  end
end
