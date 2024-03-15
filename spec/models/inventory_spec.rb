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
end
