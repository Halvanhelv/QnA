# frozen_string_literal: true

module Services
  class Search
    SCOPES = %w[questions answers comments users all].freeze
    PER_PAGE = 5

    attr_reader :query, :scope, :page, :per_page, :result

    def initialize(params)
      @query = params[:body].to_s.strip
      @scope = SCOPES.include?(params[:scope]) ? params[:scope] : 'all'
      @page = params[:page].presence || 1
      @per_page = params[:per_page].presence || PER_PAGE
    end

    def call
      @result = query.blank? ? empty : records.paginate(page: page, per_page: per_page)
    end

    private

    def records
      scope == 'all' ? multisearch : scope.classify.constantize.search_text(query)
    end

    def multisearch
      PgSearch.multisearch(query).includes(:searchable)
    end

    def empty
      PgSearch::Document.none.paginate(page: 1, per_page: per_page)
    end
  end
end
