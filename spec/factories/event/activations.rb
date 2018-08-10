FactoryBot.define do
  factory :event_activation, class: 'Event::Activation' do
    started_at "2017-07-31 01:36:58"
    ended_at "2017-07-31 01:36:58"
    association(:event)
  end
end
