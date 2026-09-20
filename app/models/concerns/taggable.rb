# frozen_string_literal: true

module Taggable
  extend ActiveSupport::Concern

  MAX_TAGS = 5

  included do
    has_many :taggings, dependent: :destroy
    has_many :tags, through: :taggings

    validate :tags_are_valid

    # A subquery keeps the question's own tags intact (a join would filter them down to the match)
    scope :tagged_with, lambda { |name|
      where(id: Tagging.joins(:tag).where(tags: { name: name.to_s.downcase }).select(:question_id))
    }
  end

  def tag_list
    tags.map(&:name).join(', ')
  end

  # Accepts "rails, hotwire" or an array; unknown tags are created on save
  def tag_list=(value)
    @tag_names = Tag.normalize(Array(value).join(','))
    self.tags = @tag_names.first(MAX_TAGS + 1).map { |name| Tag.find_or_initialize_by(name: name) }
  end

  private

  def tags_are_valid
    errors.add(:tag_list, "can have at most #{MAX_TAGS} tags") if tags.size > MAX_TAGS

    tags.each do |tag|
      next if tag.valid? || tag.errors[:name].empty?

      errors.add(:tag_list, "#{tag.name.inspect} is not a valid tag (letters, digits, . + # - only, up to #{Tag::MAX_LENGTH} characters)")
    end
  end
end
