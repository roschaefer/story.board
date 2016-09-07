require 'rails_helper'

RSpec.describe Event, type: :model do
  let(:event) { build(:event) }
  describe '#happened?' do
    it 'true if happened_at exists' do
      expect{
        event.happened_at = Time.now
      }.to change { event.happened? }.from(false).to(true)
    end
  end
end
