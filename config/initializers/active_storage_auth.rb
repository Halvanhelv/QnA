# frozen_string_literal: true

# Direct uploads (used by the Lexxy editor for images and files) are for signed-in users only.
Rails.application.config.to_prepare do
  ActiveStorage::DirectUploadsController.before_action :authenticate_user!
end
