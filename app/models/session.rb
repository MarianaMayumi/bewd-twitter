class Session < ApplicationRecord
  belongs_to :user

  before_create :set_token

  private

  def set_token
    self.token = SecureRandom.urlsafe_base64
  end
end
