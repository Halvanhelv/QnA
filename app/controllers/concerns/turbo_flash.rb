# frozen_string_literal: true

module TurboFlash
  extend ActiveSupport::Concern

  included do
    helper_method :turbo_stream_flash
  end

  private

  def turbo_stream_flash(**flash)
    turbo_stream.update('flash', partial: 'shared/flash', locals: { flash: flash })
  end
end
