FactoryBot.define do
  factory :inventory do
    items do
      {'water' => {'quantity': 1, 'points': 4 }}
    end

    user { create(:user) }
  end
end
