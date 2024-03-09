FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    gender { Faker::Gender.binary_type }
    latitude { Faker::Address.latitude.to_f }
    longitude { Faker::Address.longitude.to_f }
    age { Faker::Number.number(digits: 2) }
  end
end
