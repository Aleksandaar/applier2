class ApplicationMailer < ActionMailer::Base
  include Rails.application.routes.url_helpers
  
  default from: App::Config.mailer.default_from
  layout "mailer"

  default_url_options = { host: App::Config.mailer.default_site_host }
end
