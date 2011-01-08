ActionMailer::Base.smtp_settings = {
  :address        => "smtp.webfaction.com",
  :authentication => :login,
  :domain         => "webfaction.com",
  :port           => 25,
  :user_name      => KEYS['smtp']['username'],
  :password       => KEYS['smtp']['password']
}

ActionMailer::Base.charset = "utf-8"

ActionMailer::Base.default_url_options[:host] = KEYS['host']

# Ensure we do not send out emails (to other users) while in development
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if KEYS['smtp']['intercept']