require 'rails_helper'

describe 'Whenever Schedule' do
  before do
    load 'Rakefile'
  end
  it 'makes sure `rake` statements exist' do
    # config/schedule.rb file is used by default in constructor:
    schedule = Whenever::Test::Schedule.new
    # Makes sure the rake task is defined:
    expect(Rake::Task.task_defined?(schedule.jobs[:rake].first[:task])).to be true
  end
end
