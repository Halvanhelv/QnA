# frozen_string_literal: true

class SearchController < ApplicationController
  skip_authorization_check

  def search
    @search = Services::Search.new(search_params)
    @search.call
  end

  private

  def search_params
    params.fetch(:search, {}).permit(:body, :scope, :page, :per_page)
  end
end
