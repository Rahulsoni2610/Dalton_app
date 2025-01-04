class AddUserToCaptchas < ActiveRecord::Migration[7.1]
  def change
    add_reference :captchas, :user, null: false, foreign_key: true
  end
end
