FactoryBot.define do
  factory :inventory do
    items do
      {'water' => {'quantity': 1, 'points': 4 }}
    end

    user { create(:user) }
  end

  factory :inventory_with_items, parent: :inventory do
    items do
      {
        'water' => {'quantity': 3, 'points': 12 },
        'food' => {'quantity': 1, 'points': 3 },
        'medicine' => {'quantity': 1, 'points': 2 },
        'ammunition' => {'quantity': 1, 'points': 1 }
      }
    end
  end
end
