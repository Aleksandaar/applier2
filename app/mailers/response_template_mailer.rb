class ResponseTemplateMailer < ApplicationMailer

  def response_email(response_template, user)
    @user = user
    
    if response_template.present?
      mail(to: user.email, subject: response_template.subject) do |format|
        format.html { response_template.content_html }
        format.text { response_template.content_text }
      end
    end
  end
end
