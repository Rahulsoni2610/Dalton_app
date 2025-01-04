class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :rememberable, :validatable,
         :timeoutable, :trackable

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "current_sign_in_at", "email", "encrypted_password", "id", "id_value", "last_sign_in_at", "remember_created_at", "reset_password_sent_at", "reset_password_token", "sign_in_count", "updated_at"]
  end
end
