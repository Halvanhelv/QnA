# frozen_string_literal: true

module Services
  class DailyDigest
    # Nothing new, nothing sent: an empty digest is noise
    def send_digest
      return unless Question.recent.exists?

      User.find_each(batch_size: 500).each do |user|
        DailyDigestMailer.digest(user).deliver_later
      end
    end
  end
end
