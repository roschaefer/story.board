require 'rails_helper'

RSpec.describe "Triggers", type: :request do
	let(:user) { create(:user) }
	before { sign_in user }
	let(:report) { create(:report, id: 4711) }
	describe "GET /triggers" do
		it "works! (now write some real specs)" do
			get report_triggers_path(report)
			expect(response).to have_http_status(200)
		end
	end

	describe "POST /triggers" do
		let(:params) { { trigger: { report_id: Report.current.id, name: 'just a trigger'}} }
		it 'creates triggers' do
			expect{post('/reports/1/triggers', params: params)}.to(change{Trigger.count}.from(0).to(1))
		end

		context 'given sensor condition params' do
			let(:sensor) { create(:sensor) }

			it 'creates ' do
				params[:trigger] = params[:trigger].merge(
					'conditions_attributes'=>{
						'1500585003187'=>{
							'sensor_id'=>sensor.id,
							"from"=>"0",
							"to"=>"39",
							"_destroy"=>"false"
						}
					}
				)
				expect{post('/reports/1/triggers', params: params)}.to(change{Condition.count}.from(0).to(1))
			end
		end
	end
end
