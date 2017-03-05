FactoryGirl.define do
  factory :vacation do
    start_date DateTime.now
    end_date { start_date + 2.days }
  end

  factory :worker_vacation, parent: :vacation do
    association :vacationable, factory: :worker
  end

  factory :manager_vacation, parent: :vacation do
    association :vacationable, factory: :manager
  end
end