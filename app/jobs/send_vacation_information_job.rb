class SendVacationInformationJob < ApplicationJob
  queue_as :vacation_info

  def perform(vacation_id)
    vacation = Vacation.find(vacation_id)

    VacationMailer.vacation_email(vacation).deliver_now
  end
end
