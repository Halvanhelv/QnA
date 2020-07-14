class AttachmentController < ApplicationController
  before_action :authenticate_user!

  def destroy
    if current_user.author_of?(attachment.record)
      attachment.purge
    else
      redirect_to attachment.record if attachment.record.is_a?(Question)
      redirect_to attachment.record.question if attachment.record.is_a?(Answer)
    end
  end

  private

  def attachment
    @attachment ||= ActiveStorage::Attachment.find(params[:id])
  end
  helper_method :attachment
end
