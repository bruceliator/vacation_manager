class Vacation < ApplicationRecord
  using WorkingDays

  MAX_ONE_VACATION_DURATION = 30
  MAX_DAYS_ON_VACATION_IN_YEAR = 30
  MAX_VACATIONS_COUNT_IN_YEAR = 3
  MIN_GAP_BETWEEN_VACATIONS = 60
  MAX_MANAGERS_PART_ON_VACATION = 1/10
  MAX_WORKERS_PART_ON_VACATION = 1/2

  before_save :calculate_duration
  before_validation :create_scope

  belongs_to :vacationable, polymorphic: true

  validates_presence_of :start_date, :end_date
  validates :start_date, :end_date, overlap: { scope: 'vacationable_id', query_options: { by_type: nil } }
  validates_with VacationValidator
  scope :in_year, -> (date) { where('start_date >= ? AND start_date <= ?', date.beginning_of_year, date.end_of_year) }
  scope :ending_before_some_date, -> (date) { where('start_date >= ? AND end_date < ?', date.beginning_of_year, date) }
  scope :starting_after_some_date, -> (date) { where('start_date >= ? AND end_date < ?', date, date.end_of_year) }
  scope :in_range, -> (s, e) { where('(start_date BETWEEN ? AND ? OR end_date BETWEEN ? AND ?) OR
                                      (start_date <= ? AND end_date >= ?)', s, e, s, e, s, e) }

  def working_days_count
    Date.working_days_between(start_date, end_date)
  end

  private

  def calculate_duration
    self.duration = working_days_count
  end

  def create_scope
    record = self
    self.class.define_singleton_method(:by_type) do
      where(vacationable_type: record.vacationable_type)
    end
  end
end
