class ReminderMailer < ApplicationMailer
  default :from => "vacation@example.com"

  def reminder_email
    @users = Manager.pluck(:email) + Worker.pluck(:email)
    mail(to: @users, subject: 'Vacation schedule reminder')
  end
end
