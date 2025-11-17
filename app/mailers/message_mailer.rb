class MessageMailer < ApplicationMailer

  def new_message_notification(answer, user)
    @user = user
    @message_title = answer.structure.name
    @link_url = place_url(answer.token)
    
    mail(to: user.email, subject: 'New message(s) received')
  end

  def new_message_admin_notification(answer, user)
    @user = user
    @message_title = answer.structure.name
    @link_url = space_structure_answer_url(answer.structure, answer.structure.space, answer)
    
    mail(to: user.email, subject: 'New message(s) received')
  end
end
