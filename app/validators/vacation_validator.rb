class VacationValidator < ActiveModel::Validator

  attr_reader :errors, :record, :vacationable, :start_date, :end_date

  def validate(record)
    @record = record
    @vacationable = record.vacationable
    @start_date = record.start_date
    @end_date = record.end_date
    @errors = record.errors

    end_date_is_after_start_date
    length_validation
    current_year_limit
    start_date_in_future
    vacations_in_year
    gap_between
    on_vacation_limit
  end

  private

  def start_date_in_future
    return if blank_dates?
    if start_date.past?
      errors.add(:start_date, 'should be in future')
    end
  end

  def end_date_is_after_start_date
    return if blank_dates?
    if end_date < start_date
      errors.add(:end_date, 'cannot be before the start date')
    end
  end

  def length_validation
    return if blank_dates?
    if record.working_days_count > Vacation::MAX_ONE_VACATION_DURATION
      errors.add(:base, :vacation_length_invalid,
                 message: "length should be less then #{Vacation::MAX_ONE_VACATION_DURATION}")
    end
  end

  def current_year_limit
    return if dates_or_vacationable_blank?
    if record.vacationable.total_vacation_days_in_year(start_date) + record.working_days_count > Vacation::MAX_DAYS_ON_VACATION_IN_YEAR
      errors.add(:base, :year_limit,
                 message: 'current year limit would be exceeded')
    end
  end

  def vacations_in_year
    return if dates_or_vacationable_blank?
    if vacationable.vacations_count_in_year(start_date) == Vacation::MAX_VACATIONS_COUNT_IN_YEAR
      errors.add(:base, :vacations_limit,
                 message: 'too much vacations in this year')
    end
  end

  def gap_between
    return if dates_or_vacationable_blank?
    min_gap = Vacation::MIN_GAP_BETWEEN_VACATIONS
    gap_before = gap_before(start_date)
    gap_after = gap_after(end_date)
    if (gap_before && gap_before < min_gap) || (gap_after && gap_after < min_gap)
      errors.add(:base, :gap_value,
                 message: 'previous or next vacation too close')
    end
  end

  def on_vacation_limit
    return if dates_or_vacationable_blank?
    type = record.vacationable_type.downcase.to_sym
    on_vacation = vacationable.on_vacation_count(start_date, end_date)
    ratio = ratio_on_vacation(on_vacation)
    max_ratio = Vacation::MAX_PART_ON_VACATION[type]
    if ratio > max_ratio && on_vacation > 1
      errors.add(:base, :on_vacation_percentage,
                 message: 'too many on vacation at this period')
    end
  end

  def blank_dates?
    end_date.blank? || start_date.blank?
  end

  def dates_or_vacationable_blank?
    vacationable.blank? || blank_dates?
  end

  def gap_before(date)
    previous_date = vacationable.previous_vacation_end_date(date)
    (date - previous_date).to_i / 86400 if previous_date
  end

  def gap_after(date)
    next_date = vacationable.next_vacation_start_date(date)
    (next_date - date).to_i / 86400 if next_date
  end

  def ratio_on_vacation(on_vacation)
    total = vacationable.class.count
    on_vacation.to_f/total
  end
end