class SendVacationInformationJob < ApplicationJob
  queue_as :vacation_info

  def perform(vacation)
    VacationMailer.vacation_email(vacation).deliver_later
  end
end
