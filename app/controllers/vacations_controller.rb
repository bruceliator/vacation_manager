class VacationsController < ApplicationController
  before_action :authenticate_manager!
  before_action :set_vacationable

  def create
    @vacation = @vacationable.vacations.new(vacation_params)
    @vacation.save
    redirect_to @vacationable, notice: 'Vacation created'
  end

  private

  def vacation_params
    params.require(:vacation).permit(:start_date, :end_date)
  end

  def set_vacationable
    klass = [Manager, Worker].detect{|c| params["#{c.name.underscore}_id"]}
    @vacationable = klass.find(params["#{klass.name.underscore}_id"])
  end
end
