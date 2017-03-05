module WorkingDays
  refine Date.singleton_class do
    def working_days_between(start_date, end_date)
      business_days = 0
      date = start_date
      while date <= end_date
        business_days = business_days + 1 unless date.saturday? || date.sunday?
        date = date + 1.day
      end
      business_days
    end
  end
end
