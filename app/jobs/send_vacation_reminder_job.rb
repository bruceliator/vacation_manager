class SendVacationReminderJob < ApplicationJob
  queue_as :vacation_reminder

  def perform(*args)
    ReminderMailer.reminder_email.deliver_later
  end
end
