require 'rails_helper'
require 'support/shared_examples/database_unique_attribute'

RSpec.describe Variable, type: :model do
  describe '#key' do
    it_behaves_like 'database unique attribute', :variable, key: 'abc'
  end

  specify { expect(build(:variable, key: "")).not_to be_valid }
end
