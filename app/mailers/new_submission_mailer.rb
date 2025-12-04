class NewSubmissionMailer < ApplicationMailer

  def new_submission(structure, user)
    @link_url = space_structure_answers_url(structure, structure.space)

    structure.space.users.each do |user|
      @user = user
      mail(to: user.email, subject: "New Submission on #{structure.name}")
    end
  end
end
