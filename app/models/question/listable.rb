# frozen_string_literal: true

module Question::Listable
  extend ActiveSupport::Concern

  SORTS = %w[newest unanswered top].freeze
  PER_PAGE = 15

  included do
    scope :with_details, -> { includes(:user, :tags, :acceptance).with_rich_text_body }
    scope :newest_first, -> { reorder(id: :desc) }
    scope :unanswered, -> { where.missing(:answers) }
    scope :top_rated, -> {
      rating = '(SELECT COALESCE(SUM(score), 0) FROM votes WHERE votable_type = \'Question\' AND votable_id = questions.id)'
      reorder(Arel.sql("#{rating} DESC, questions.id DESC"))
    }
  end

  class_methods do
    # Question list: filtered by tag, ordered by `sort` (newest, unanswered or top)
    def listing(sort: 'newest', tag: nil)
      questions = with_details
      questions = questions.tagged_with(tag) if tag.present?

      case sort
      when 'unanswered' then questions.unanswered.newest_first
      when 'top'        then questions.top_rated
      else                   questions.newest_first
      end
    end
  end
end
