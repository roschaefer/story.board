FactoryGirl.define do
  factory :channel do
    name "sensorstory"

    initialize_with do
      Channel.find_or_create_by(name: name) do |c|
        c.report = build(:report)
      end
    end
  end
end
