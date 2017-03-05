FactoryGirl.define do
  factory :worker do
    email { Faker::Internet.email }
  end
end