FactoryGirl.define do
  factory :manager do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end
end