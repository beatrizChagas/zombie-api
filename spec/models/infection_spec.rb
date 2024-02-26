require 'rails_helper'

RSpec.describe Infection, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:reported_by) }
  end
end
