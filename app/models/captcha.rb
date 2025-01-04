class Captcha < ApplicationRecord
  belongs_to :user

  before_save :set_is_correct

  def self.ransackable_attributes(auth_object = nil)
    ["captcha_text", "created_at", "id", "id_value", "is_correct", "updated_at", "user_id", "user_input"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end

  private

  def set_is_correct
    self.is_correct = user_input == captcha_text
  end
end
