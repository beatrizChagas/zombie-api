require 'rails_helper'

RSpec.describe Infection, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:infected_user) }
  end

  describe '.infected_users_count' do
    it 'returns the number of infected users' do
      user = create(:user)
      user2 = create(:user)
      user3 = create(:user)
      infected_user = create(:user)

      create(:infection, user: user, infected_user: infected_user)
      create(:infection, user: user2, infected_user: infected_user)
      create(:infection, user: user3, infected_user: infected_user)

      expect(Infection.infected_users_count).to eq(1)
    end
  end
end
