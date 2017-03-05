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
  scope :in_range_by_type, -> (range_start, range_end, type) { where('(vacationable_type = :type) AND
                                                            ((start_date BETWEEN :s AND :f OR end_date BETWEEN :s AND :f) OR
                                                            (start_date <= :s AND end_date >= :f))', type: type, s: range_start, f: range_end) }

  class << self
    def valid_gaps?(range_start, range_end)
      where("(end_date < :rs AND DATE_PART('day', :rs - end_date) < :min_gap) OR
           (start_date > :re AND DATE_PART('day', start_date - :re) < :min_gap)",
            min_gap: MIN_GAP_BETWEEN_VACATIONS, rs: range_start, re: range_end).empty?
    end
  end

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
