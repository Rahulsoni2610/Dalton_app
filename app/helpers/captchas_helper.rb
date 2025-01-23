module CaptchasHelper
  def generate_unique_for_user(user)
    loop do
      captcha = random_text
      unless user.captchas.where(captcha_text: captcha).exists?
        return captcha
      end
    end
  end

  def random_text
    numbers = [*'0'..'9'].sample(2)
    uppercase = [*'A'..'Z'].sample(2)
    lowercase = [*'a'..'z'].sample(2)
    remaining = ([*'0'..'9', *'A'..'Z', *'a'..'z'] - (numbers + uppercase + lowercase)).sample(4)

    (numbers + uppercase + lowercase + remaining).shuffle.join
  end
end
