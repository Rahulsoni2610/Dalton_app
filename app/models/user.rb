class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable,
         :timeoutable

  has_many :captchas

  validates :username, presence: true, uniqueness: true, length: { in: 4..20 }
  validates :username, format: { with: /\A[a-zA-Z0-9_]+\z/, message: "only allows letters, numbers, and underscores" }


  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "encrypted_password", "id", "id_value", "is_active", "remember_created_at", "reset_password_sent_at", "reset_password_token", "updated_at", "username"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["captchas"]
  end

  def active_for_authentication?
    super and self.is_active?
  end

  def captcha_accuracy
    total_captchas = captchas.count
    correct_captchas = captchas.where(is_correct: true).count

    return 'N/A' if total_captchas.zero?

    ((correct_captchas.to_f / total_captchas) * 100).round(2)
  end

  def self.authentication_keys
    [:username]
  end
end
