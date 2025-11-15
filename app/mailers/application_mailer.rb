class ApplicationMailer < ActionMailer::Base
  include Rails.application.routes.url_helpers
  
  default from: "from@example.com"
  layout "mailer"

  default_url_options = { host: ENV["MAIL_HOST"] || "localhost:3000" }
end
