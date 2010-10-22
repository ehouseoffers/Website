ActionMailer::Base.smtp_settings = {
  :address        => "smtp.webfaction.com",
  :authentication => :login,
  :domain         => "webfaction.com",
  :port           => 25,
  :user_name      => "younker_test",
  :password       => "T3stpwd"
}

ActionMailer::Base.default_url_options[:host] = 'localhost:3000'

# Ensure we do not send out emails (to other users) while in development
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?