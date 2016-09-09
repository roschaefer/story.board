require 'rails_helper'
require 'support/shared_examples/database_unique_attribute'

RSpec.describe Actor, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
  describe '#name' do
    it_behaves_like 'database unique attribute', :actor, name: 'Whatever'
  end
end
