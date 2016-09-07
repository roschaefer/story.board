require 'rails_helper'
require 'support/shared_examples/database_unique_attribute'

RSpec.describe Event, type: :model do
  let(:event) { build(:event) }

  describe '#name' do
    it_behaves_like 'database unique attribute', :event, name: 'XYZ'

    it 'must be given' do
      expect(build(:event, name: nil)).not_to be_valid
    end
  end

  describe '#happened?' do
    it 'true if happened_at exists' do
      expect{
        event.happened_at = Time.now
      }.to change { event.happened? }.from(false).to(true)
    end
  end
end
