require 'rails_helper'

RSpec.describe Command, type: :model do
  describe '#status' do
    it 'default is :pending' do
      is_expected.to be_pending
    end
  end
end
