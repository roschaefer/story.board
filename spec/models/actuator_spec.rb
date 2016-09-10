require 'rails_helper'
require 'support/shared_examples/database_unique_attribute'

RSpec.describe Actuator, type: :model do

  describe '#name' do
    it_behaves_like 'database unique attribute', :actuator, name: 'Whatever'
  end

  describe '#activate!' do
    let(:actuator) { create(:actuator) }
    subject { actuator.activate! }
    it 'creates a command' do
      expect { subject }.to change { Command.count }.from(0).to(1)
    end

    it 'created command belongs to actuator' do
      expect { subject }.to change { actuator.reload; actuator.commands.size }.from(0).to(1)
    end

    it 'created command is not yet executed' do
      subject
      expect(Command.last).to be_pending
    end

    it 'created command\'s function == :activate' do
      subject
      expect(Command.last.function).to eq 'activate'
    end
  end
end
