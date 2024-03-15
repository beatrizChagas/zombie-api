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
end
