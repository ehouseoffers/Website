class DevelopmentMailInterceptor
  def self.delivering_email(message)
    message.subject = "[original recipient: #{message.to}] #{message.subject}"
    message.to = KEYS['smtp']['intercept_recipient']
  end
end