module HasVacation
  extend ActiveSupport::Concern

  included do
    has_many :vacations, as: :vacationable, dependent: :destroy
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

  def previous_vacation_end_date(date)
    vacations.ending_before_some_date(date).maximum(:end_date)
  end
  def next_vacation_start_date(date)
    vacations.starting_after_some_date(date).minimum(:start_date)
  end
end

