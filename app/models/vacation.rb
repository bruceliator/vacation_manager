class Vacation < ApplicationRecord
  using WorkingDays

  MAX_ONE_VACATION_DURATION = 30
  MAX_DAYS_ON_VACATION_IN_YEAR = 30
  MAX_VACATIONS_COUNT_IN_YEAR = 3
  MIN_GAP_BETWEEN_VACATIONS = 60
  MAX_PART_ON_VACATION = { manager: 0.1, worker: 0.5 }

  before_save :calculate_duration
  before_validation :create_scope

  belongs_to :vacationable, polymorphic: true

  validates_presence_of :start_date, :end_date
  validates :start_date, :end_date, overlap: { scope: 'vacationable_id', query_options: { by_type: nil } }
  validates_with VacationValidator
  scope :in_year, -> (date) { where('start_date >= ? AND start_date <= ?', date.beginning_of_year, date.end_of_year) }
  scope :ending_before_some_date, -> (date) { where('start_date >= ? AND end_date < ?', date.beginning_of_year, date) }
  scope :starting_after_some_date, -> (date) { where('start_date >= ? AND end_date < ?', date, date.end_of_year) }
  scope :in_range_by_type, -> (range_start, range_end, type) { where('(vacationable_type = :type) AND
                                                            ((start_date BETWEEN :s AND :f OR end_date BETWEEN :s AND :f) OR
                                                            (start_date <= :s AND end_date >= :f))', type: type, s: range_start, f: range_end) }

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
