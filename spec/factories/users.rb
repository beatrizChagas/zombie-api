FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    gender { Faker::Gender.binary_type }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    age { Faker::Number.number(digits: 2) }
  end
end
