# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Inventory, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_length_of(:items) }
    it { should validate_presence_of(:user_id) }
  end

  describe '.calculate_points' do
    it 'returns the points of the items' do
      user = create(:user)
      create(:inventory, user:)

      expect(Inventory.calculate_points('water', 1)).to eq(4)
    end
  end

  describe '.average_items_quantity_per_user' do
    it 'returns the average quantity of items per user' do
      user = create(:user)
      user2 = create(:user)

      create(:inventory, user: user)
      create(:inventory_with_items, user: user2)

      expect(Inventory.average_items_quantity_per_user).to eq('ammunition' => 0.5,
                                                              'food' => 0.5,
                                                              'medicine' => 0.5,
                                                              'water' => 2.0)
    end
  end

  describe '#transfer' do
    it 'transfers items to target user' do
      user = create(:user)
      user2 = create(:user)

      create(:inventory_with_items, user: user)
      create(:inventory, user: user2)

      user.inventory.transfer(user.inventory.items, user2)

      expect(user2.inventory.items).to eq('ammunition' => { 'quantity' => 1, 'points' => 1 },
                                          'food' => { 'quantity' => 1, 'points' => 3 },
                                          'medicine' => { 'quantity' => 1, 'points' => 2 },
                                          'water' => { 'quantity' => 4, 'points' => 16 })

      expect(user.inventory.items).to eq('ammunition' => {'points' => 0, 'quantity' => 0},
                                         'food' => {'points' => 0, 'quantity' => 0},
                                         'medicine' => {'points' => 0, 'quantity' => 0},
                                         'water' => {'points' => 0, 'quantity' => 0},)
    end
  end

  describe '#total_points' do
    it 'returns the total points of the items' do
      user = create(:user)
      create(:inventory_with_items, user: user)

      expect(user.inventory.total_points).to eq(18)
    end
  end
end
