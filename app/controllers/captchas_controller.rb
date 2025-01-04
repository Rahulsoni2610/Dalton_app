class CaptchasController < ApplicationController
  before_action :authenticate_user!

  def new
    @captcha = Captcha.new
  end

  def create
    @captcha = current_user.captchas.new(captcha_params)

    if @captcha.save
      if check_failed_captchas
        return flash[:alert] = "You have been logged out due to multiple empty captcha attempts."
      end

      render turbo_stream: turbo_stream.update('captcha_screen', partial: 'captcha_form')
    else
      render turbo_stream: turbo_stream.update('captcha_screen', partial: 'captcha_form')
    end
  end

  private
  def check_failed_captchas
    recent_captchas = current_user.captchas.order(created_at: :desc).limit(4)

    if recent_captchas.size == 4 && recent_captchas.all? { |captcha| captcha.user_input.blank? }
      sign_out current_user
      return true
    end
    false
  end

  def captcha_params
    params.require(:captcha).permit(:user_input, :captcha_text, :is_correct)
  end
end
