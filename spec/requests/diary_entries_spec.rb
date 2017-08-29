require 'rails_helper'

RSpec.describe "DiaryEntries", type: :request do
  let(:report) { create(:report) }
  let(:headers) { { 'ACCEPT' => 'application/json', 'Content-Type' => "application/json" } }
  let(:params) { {} }
  let(:js) { JSON.parse(response.body) }
  describe "GET" do
    describe '/reports/:report_id/diary_entries/:id' do
      let(:url) { "/reports/#{report.id}/diary_entries/#{diary_entry.id}"}

      let(:diary_entry) { create(:diary_entry, report: report) }
      it 'sends only 3 text components' do
        create_list(:text_component, 4, report: report)
        action
        expect(js['text_components'].count).to eq 3
      end

      describe 'priorities' do
        it 'define order of text components' do
          create(:text_component, report: report, heading: 'Low priority component 1',  triggers: create_list(:trigger, 1, priority: :low))
          create(:text_component, report: report, heading: 'Low priority component 2',  triggers: create_list(:trigger, 1, priority: :low))
          create(:text_component, report: report, heading: 'Medium priority component', triggers: create_list(:trigger, 1, priority: :medium))
          create(:text_component, report: report, heading: 'Low priority component 3',  triggers: create_list(:trigger, 1, priority: :low))
          create(:text_component, report: report, heading: 'High priority component',   triggers: create_list(:trigger, 1, priority: :high))
          action
          expect(js['text_components'][0]['heading']).to eq 'High priority component'
          expect(js['text_components'][1]['heading']).to eq 'Medium priority component'
          expect(js['text_components'].count).to eq 3
        end
      end
    end

    let(:action) { get url, params: params, headers: headers }
    describe '/reports/:id/diary_entries' do
      let(:url) { "/reports/#{report.id}/diary_entries"}

      let(:diary_entries) do
        create(:diary_entry, id: 1, report: report, moment: '2017-07-16T12:19:00.000Z', release: 'final')
        create(:diary_entry, id: 2, report: report, moment: '2017-07-17T12:19:00.000Z', release: 'debug')
        create(:diary_entry, id: 3, report: report, moment: '2017-07-18T12:19:00.000Z', release: 'final')
      end

      describe 'filter' do
        before do
          diary_entries
          action
        end

        describe 'for #moment' do
          context 'invalid date' do
            let(:params) { { to: 'bullshit' } }
            subject { response }
            it { is_expected.to have_http_status(:unprocessable_entity) }
          end

          context 'params: { to: "2017-07-17T12:19:00.000Z" }' do
            let(:params) { { to: "2017-07-17T12:19:00.000Z" } }
            it 'contains only diary entries 1 and 2' do
              expect(js[0]['id']).to eq 1
              expect(js[1]['id']).to eq 2
              expect(js.count).to eq 2
            end
          end

          context 'params: { from: "2017-07-17T12:19:00.000Z" }' do
            let(:params) { { from: "2017-07-17T12:19:00.000Z" } }
            it 'contains only diary entries 2 and 3' do
              expect(js[0]['id']).to eq 2
              expect(js[1]['id']).to eq 3
              expect(js.count).to eq 2
            end
          end
        end

        describe 'for #release' do
          context 'params: { filter: {release: "debug" }' do
            let(:params) { { release: "debug" } }
            it 'contains only diary entries 2 and the live entry' do
              expect(js[0]['id']).to eq 0
              expect(js[1]['id']).to eq 2
              expect(js.count).to eq 2
            end
          end
        end
      end
    end
  end
end
