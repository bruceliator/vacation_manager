class VacationMailer < ActionMailer::Base
  default :from => "vacation@example.com"

  def vacation_email(vacation)
    @managers = Manager.all
    @user = vacation.vacationable
    @vacation = vacation
    mail(to: @managers.pluck(:email), subject: "Vacation for #{@user.email} has been created")
  end
end