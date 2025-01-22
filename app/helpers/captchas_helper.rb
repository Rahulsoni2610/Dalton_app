module CaptchasHelper
  def random_text_generator
    numbers = [*'0'..'9'].sample(2)
    uppercase = [*'A'..'Z'].sample(2)
    lowercase = [*'a'..'z'].sample(2)
    remaining = ([*'0'..'9', *'A'..'Z', *'a'..'z'] - (numbers + uppercase + lowercase)).sample(2)

    (numbers + uppercase + lowercase + remaining).shuffle.join
  end

end
