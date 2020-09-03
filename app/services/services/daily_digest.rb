class Services::DailyDigest
  def send_digest
    User.find_each(batch_size: 500).each do |user|
      DailyDigestMailer.digest(user).deliver_later
    end
  end
end
