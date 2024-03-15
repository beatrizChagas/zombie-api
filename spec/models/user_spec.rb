# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_one(:inventory) }
    it { should have_many(:infection) }
  end

  describe 'validations' do
    it { should validate_length_of(:name).is_at_least(3) }
    it { should validate_presence_of(:age) }
    it { should validate_presence_of(:gender) }
    it { should validate_presence_of(:latitude) }
    it { should validate_presence_of(:longitude) }
  end

  describe '#infected?' do
    it 'returns true when user is infected' do
      user = create(:user)
      user2 = create(:user)
      user3 = create(:user)
      user4 = create(:user)

      create(:infection, infected_user: user, user: user2)
      create(:infection, infected_user: user, user: user3)
      create(:infection, infected_user: user, user: user4)

      expect(user.infected?).to be true
    end

    it 'returns false when user is not infected' do
      user = create(:user)

      expect(user.infected?).to be false
    end
  end
end
