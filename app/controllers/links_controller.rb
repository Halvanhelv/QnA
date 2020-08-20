class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action :link

  authorize_resource

  def destroy
      link.destroy
      redirect_to link.linkable if link.linkable.is_a?(Question)
      redirect_to link.linkable.question if link.linkable.is_a?(Answer)
  end

  private

  def link
    @link ||= Link.find(params[:id])
  end
  helper_method :link
end
