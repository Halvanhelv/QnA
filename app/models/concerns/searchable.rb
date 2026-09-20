# frozen_string_literal: true

# Full-text search (PostgreSQL) for a model.
# Provides `Model.search_text(query)` and registers the model in the global multisearch index.
module Searchable
  extend ActiveSupport::Concern

  included do
    include PgSearch::Model
  end

  class_methods do
    def searchable_by(*columns)
      multisearchable against: columns
      pg_search_scope :search_text, against: columns, using: { tsearch: { prefix: true, any_word: true } }
    end
  end
end
