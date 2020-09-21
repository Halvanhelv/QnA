# frozen_string_literal: true

module Services
  class SphinxSearch
    attr_reader :body, :scope, :result, :params

    SCOPE = %w[questions answers comments users all].freeze
    PER_PAGE = 5
    def initialize(params)
      @params = params
      @body = params[:body]
      @scope = params[:scope]
    end

    def call
      options = {
        page: params[:page].nil? ? 1 : params[:page],
        per_page: params[:per_page].nil? ? PER_PAGE : params[:per_page] # для показа n-го количества сущностей на странице. если в запросе будет params[:per_page]
      }
      @request = @body.split(/'([^']+)'|"([^"]+)"|\s+|\+/).reject(&:empty?).map(&:inspect)

      @result = if SCOPE.include?(scope) && scope == 'all'
                  ThinkingSphinx.search(ThinkingSphinx::Query.escape(@request.to_s), options)
                else
                  scope.singularize.capitalize.constantize.search(ThinkingSphinx::Query.escape(@request.to_s), options)
                end
    end
  end
end
