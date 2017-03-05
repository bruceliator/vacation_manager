FactoryGirl.define do
  factory :vacation do
    start_date 1.day.from_now
    end_date { start_date + 2.days }
    association :vacationable, factory: [:manager, :worker].sample
  end

  factory :worker_vacation, parent: :vacation do
    association :vacationable, factory: :worker
  end

  factory :manager_vacation, parent: :vacation do
    association :vacationable, factory: :manager
  end
end