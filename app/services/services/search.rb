# frozen_string_literal: true

module Services
  # Full-text search over the SearchDocument index.
  #
  # - English and Russian stemming ("upgrading" finds "upgrade", "обновлению" finds "обновить")
  # - every word must match, the last one may be a prefix while typing ("upgr")
  # - when nothing matches exactly, typos in titles and tags are tolerated through trigram similarity ("hotwrie")
  # - title and tag matches rank above body matches
  # - each hit carries a highlighted snippet of its body
  class Search
    SCOPES = %w[all questions answers comments].freeze
    KINDS = {
      'all' => SearchDocument::KINDS,
      'questions' => %w[Question],
      'answers' => %w[Answer],
      'comments' => %w[Comment]
    }.freeze
    PER_PAGE = 10
    MAX_TOKENS = 8
    FUZZY_THRESHOLD = 0.45
    FUZZY_MIN_LENGTH = 4
    MARK_OPEN = '⟦'
    MARK_CLOSE = '⟧'

    attr_reader :query, :scope, :page, :per_page, :result, :snippets

    def initialize(params)
      @query = params[:body].to_s.strip
      @scope = SCOPES.include?(params[:scope]) ? params[:scope] : 'all'
      @page = params[:page].presence || 1
      @per_page = params[:per_page].to_i.clamp(1, 50) if params[:per_page].present?
      @per_page ||= PER_PAGE
    end

    def call
      @result = tokens.empty? ? empty : find.paginate(page: page, per_page: per_page)
      @snippets = snippets_for(@result.map(&:id))
      @result
    end

    # Lowercased words of the query (ё = е), without punctuation and single letters ("c" matches everything)
    def tokens
      @tokens ||= query.downcase.tr('ё', 'е').scan(/[\p{L}\p{N}]+/)
                       .reject { |token| token.length == 1 && token.match?(/\p{L}/) }.first(MAX_TOKENS)
    end

    private

    # Exact (stemmed) matches first; only when there are none, fall back to tolerating typos
    def find
      exact = relevant(fuzzy: false)
      fuzzy_allowed? && !exact.exists? ? relevant(fuzzy: true) : exact
    end

    def relevant(fuzzy:)
      SearchDocument.where(searchable_type: KINDS.fetch(scope))
                    .where(match_sql(fuzzy))
                    .reorder(Arel.sql("#{rank_sql(fuzzy)} DESC, search_documents.id DESC"))
                    .includes(:searchable)
    end

    def match_sql(fuzzy)
      match = "search_documents.tsv @@ #{tsquery(:english, :russian)}"
      match += " OR #{similarity_sql} >= #{FUZZY_THRESHOLD}" if fuzzy
      match
    end

    def rank_sql(fuzzy)
      rank = "ts_rank_cd(search_documents.tsv, #{tsquery(:english, :russian)})"
      rank += " + 0.4 * #{similarity_sql}" if fuzzy
      rank
    end

    # "rails upgr" -> to_tsquery('rails & upgr:*'), stemmed by both dictionaries
    def tsquery(*configs)
      parts = configs.map { |config| sanitize(["to_tsquery('#{config}', ?)", tsquery_text]) }
      "(#{parts.join(' || ')})"
    end

    def tsquery_text
      tokens.each_with_index.map { |token, index| index == tokens.size - 1 ? "#{token}:*" : token }.join(' & ')
    end

    def similarity_sql
      sanitize(["word_similarity(?, lower(search_documents.title || ' ' || search_documents.tags))", tokens.join(' ')])
    end

    def fuzzy_allowed?
      tokens.join(' ').length >= FUZZY_MIN_LENGTH
    end

    def snippets_for(ids)
      return {} if ids.empty?

      config = query.match?(/\p{Cyrillic}/) ? 'russian' : 'english'
      options = "StartSel=#{MARK_OPEN}, StopSel=#{MARK_CLOSE}, MaxFragments=1, MaxWords=28, MinWords=12"
      headline = sanitize(["ts_headline('#{config}', body, to_tsquery('#{config}', ?), ?)", tsquery_text, options])

      SearchDocument.where(id: ids).pluck(:id, Arel.sql(headline)).to_h { |id, text| [id, escape_marks(text)] }
    end

    # The body is user text: escape it, then turn only our own markers into <mark>
    def escape_marks(text)
      ERB::Util.html_escape(text).gsub(MARK_OPEN, '<mark>').gsub(MARK_CLOSE, '</mark>').html_safe
    end

    def empty
      SearchDocument.none.paginate(page: 1, per_page: per_page)
    end

    def sanitize(array)
      SearchDocument.sanitize_sql_array(array)
    end
  end
end
