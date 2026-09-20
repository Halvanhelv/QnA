# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action :link, only: %i[destroy]

  authorize_resource

  def destroy
    link.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(link) }
      format.html { redirect_back_or_to root_path }
    end
  end

  private

  def link
    @link ||= Link.find(params[:id])
  end
  helper_method :link
end
