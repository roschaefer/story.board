require 'rails_helper'
require 'support/shared_examples/database_unique_attribute'

RSpec.describe Variable, type: :model do
  describe '#key' do
    before { create(:variable, key: 'abc', report: Report.current) } # create the duplicate record
    specify { expect( build(:variable, key: 'abc', report: Report.current) ).not_to be_valid }
    specify { expect( build(:variable, key: 'abc', report: Report.last) ).to be_valid }
  end

  specify { expect(build(:variable, key: "")).not_to be_valid }
end
