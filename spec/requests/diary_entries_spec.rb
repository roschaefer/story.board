require 'rails_helper'

RSpec.describe "DiaryEntries", type: :request do
  let(:report) { create(:report) }
  let(:headers) { { 'ACCEPT' => 'application/json', 'Content-Type' => "application/json" } }
  let(:params) { {} }
  let(:js) { JSON.parse(response.body) }
  describe "GET" do
    let(:action) { get url, params: params, headers: headers }
    describe "/reports/:id/diary_entries" do
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
