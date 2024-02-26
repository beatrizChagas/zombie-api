FactoryBot.define do
  factory :inventory do
    items {
      {
        'water' => {
          'points' => 4,
          'quantity' => 1
        },
        'food' => {
          'points' => 3,
          'quantity' => 1
        },
        'medicine' => {
          'points' => 2,
          'quantity' => 1
        },
        'ammunition' => {
          'points' => 1,
          'quantity' => 1
        }
      }
    }
    user { create(:user) }
  end
end
