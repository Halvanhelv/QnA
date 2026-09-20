# frozen_string_literal: true

# Search index row for a question, answer or comment. Kept in sync by the Searchable concern.
class SearchDocument < ApplicationRecord
  KINDS = %w[Question Answer Comment].freeze

  belongs_to :searchable, polymorphic: true

  # Creates or refreshes the row for `record`
  def self.reindex(record)
    document = record.search_document_attributes
    upsert(document.merge(searchable_type: record.class.name, searchable_id: record.id, created_at: Time.current, updated_at: Time.current),
           unique_by: %i[searchable_type searchable_id], update_only: %i[title body tags updated_at],
           record_timestamps: false)
  end

  # Rebuilds the whole index (after a deploy that changes what is indexed)
  def self.rebuild
    delete_all
    KINDS.each { |kind| kind.constantize.find_each { |record| reindex(record) } }
  end
end
