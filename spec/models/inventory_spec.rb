require 'rails_helper'

RSpec.describe Inventory, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_length_of(:items) }
    it { should serialize(:items) }
  end
end