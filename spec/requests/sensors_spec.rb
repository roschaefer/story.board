require 'rails_helper'
require 'support/shared_examples/report_namespaced_controller'

RSpec.describe 'Sensors', type: :request do
  context 'given a sensor type' do
    let(:sensor_type) { create(:sensor_type, id: 4567) } 
    before { sensor_type }
    it_behaves_like 'a report/ namespaced controller', Sensor, { sensor_type_id: 4567 }
  end
end
