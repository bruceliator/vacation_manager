module HasVacation
  extend ActiveSupport::Concern

  included do
    has_many :vacations, as: :vacationable, dependent: :destroy
  end

  def on_vacation_count(start_date, end_date)
    type = self.class.name
    Vacation.in_range_by_type(start_date, end_date, type).count
  end

  def total_vacation_days_in_year(date)
    vacations_in_year(date).sum(:duration)
  end

  def vacations_count_in_year(date)
    vacations_in_year(date).count
  end

  def vacations_in_year(date)
    vacations.in_year(date)
  end
end

