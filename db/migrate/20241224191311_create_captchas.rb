class CreateCaptchas < ActiveRecord::Migration[7.1]
  def change
    create_table :captchas do |t|
      t.string :captcha_text
      t.string :user_input
      t.boolean :is_correct

      t.timestamps
    end
  end
end
