FactoryBot.define do
  factory :infection do
    infected_user { create(:user) }
    user { create(:user) }
  end
end
