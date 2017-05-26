require 'rails_helper'
require 'support/shared_examples/database_unique_attribute'

RSpec.describe User, type: :model do
  describe '#email' do
    it_behaves_like 'database unique attribute', :user, email: 'blablabla@example.org'
  end
  describe '#name' do
    it_behaves_like 'database unique attribute', :user, name: 'XYZ'
  end
end
