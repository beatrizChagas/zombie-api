FactoryBot.define do
  factory :infection do
    reported_by { create(:user) }
    user { create(:user) }
  end
end
