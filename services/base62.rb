class Base62
  CHARSET = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ".chars
  BASE = CHARSET.size

  def self.encode(num)
    return CHARSET[num] if num.zero?
    raise ArgumentError, "Number must be non-negative" if num.negative?

    str = ""
    while num > 0
      str = CHARSET[num % BASE] + str
      num /= BASE
    end
    str
  end
end
