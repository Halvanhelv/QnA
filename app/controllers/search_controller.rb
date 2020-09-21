# frozen_string_literal: true

class SearchController < ApplicationController
  skip_authorization_check

  def search
    @search = Services::SphinxSearch.new(search_params)
    @search.call
  end

  private

  def search_params
    params.require(:search).permit(:body, :scope, :page, :per_page)
  end
end
