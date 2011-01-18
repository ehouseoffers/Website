ActionMailer::Base.smtp_settings = {
  :address        => KEYS['smtp']['address'],
  :authentication => KEYS['smtp']['authentication'].intern,
  :domain         => KEYS['smtp']['domain'],
  :port           => KEYS['smtp']['port'],
  :user_name      => KEYS['smtp']['username'],
  :password       => KEYS['smtp']['password']
}

ActionMailer::Base.charset = "utf-8"

ActionMailer::Base.default_url_options[:host] = KEYS['host']

# Ensure we do not send out emails (to other users) while in development
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if KEYS['smtp']['intercept']