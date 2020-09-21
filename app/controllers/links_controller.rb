# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action :link, only: %i[destroy]

  authorize_resource

  def destroy
    link.destroy
  end

  private

  def link
    @link ||= Link.find(params[:id])
  end
  helper_method :link
end
