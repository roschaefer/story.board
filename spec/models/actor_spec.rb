require 'rails_helper'
require 'support/shared_examples/database_unique_attribute'

RSpec.describe Actor, type: :model do

  describe '#name' do
    it_behaves_like 'database unique attribute', :actor, name: 'Whatever'
  end

  describe '#activate!' do
    let(:actor) { create(:actor) }
    subject { actor.activate! }
    it 'creates a command' do
      expect { subject }.to change { Command.count }.from(0).to(1)
    end

    it 'created command belongs to actor' do
      expect { subject }.to change { actor.reload; actor.commands.size }.from(0).to(1)
    end

    it 'created command is not yet executed' do
      subject
      expect(Command.last.executed).to be_falsy
    end

    it 'created command\'s value == :on' do
      subject
      expect(Command.last.value).to eq 'on'
    end
  end
end
