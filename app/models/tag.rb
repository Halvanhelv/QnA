# frozen_string_literal: true

class Tag < ApplicationRecord
  # Letters of any alphabet (Cyrillic included), digits, and . + # - inside the name
  NAME_FORMAT = /\A[\p{L}\p{N}][\p{L}\p{N}.+#-]*\z/
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
