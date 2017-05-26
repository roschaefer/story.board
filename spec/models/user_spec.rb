require 'rails_helper'
require 'support/shared_examples/database_unique_attribute'

RSpec.describe User, type: :model do
  describe '#email' do
    it_behaves_like 'database unique attribute', :user, email: 'blablabla@example.org'
    describe 'without name' do
      subject { build(:user, name: '   ') }
      it { is_expected.not_to be_valid }
    end
  end
  describe '#name' do
    it_behaves_like 'database unique attribute', :user, name: 'XYZ'
  end
end
