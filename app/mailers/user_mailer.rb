class UserMailer < ApplicationMailer
  def send_credentials(user, entered_password)
    @user = user
    @entered_password = entered_password

    mail(to: @user.email, subject: 'Your Account Credentials')
  end
end
