class LinksController < ApplicationController
  before_action :authenticate_user!

  def destroy
    if current_user.author_of?(link.linkable)
      link.destroy
    else
      redirect_to link.linkable if link.linkable.is_a?(Question)
      redirect_to link.linkable.question if link.linkable.is_a?(Answer)
    end
  end

  private

  def link
    @link ||= Link.find(params[:id])
  end
  helper_method :link
end
