class ApplicationMailer < ActionMailer::Base
  include Rails.application.routes.url_helpers
  
  default from: App::Config.mailer.no_replay_email
  layout "mailer"

  default_url_options = { host: App::Config.mailer.default_site_host }
end
