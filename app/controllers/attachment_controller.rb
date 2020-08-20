class AttachmentController < ApplicationController
  before_action :authenticate_user!
  before_action :attachment

  authorize_resource

  def destroy
      attachment.purge
      redirect_to attachment.record if attachment.record.is_a?(Question)
      redirect_to attachment.record.question if attachment.record.is_a?(Answer)

  end

  private

  def attachment
    @attachment ||= ActiveStorage::Attachment.find(params[:id])
  end
  helper_method :attachment
end
