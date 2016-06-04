require 'rails_helper'

RSpec.describe Report, type: :model do
  context 'given a report' do
    let(:report) { create(:report) }
    before { report }
    specify { expect(Report.current).to eql report }
  end
end
