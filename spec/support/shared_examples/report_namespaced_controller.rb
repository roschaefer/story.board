RSpec.shared_examples 'a report/ namespaced controller' do |model, additional_attributes|
  context 'signed in' do
    let(:user) { create(:user) }
    before { sign_in user }

    describe 'edit :report_id' do
      let(:new_report) { create(:report, id: 69) }
      let(:old_report) { create(:report, id: 1234) }
      let(:model_symbol) { model.name.underscore.to_sym }
      let(:controller) { model.name.underscore.pluralize }
      before do
        old_report
        new_report
      end

      describe 'POST' do
        subject { post "/reports/#{old_report.id}/#{model_symbol}s", params: params }
        let(:valid_attributes) { attributes_for(model_symbol).merge(additional_attributes.to_h) }
        let(:params) { { model_symbol => valid_attributes.merge({ report_id: 69 }) } }
        it 'redirects to new report' do
          is_expected.to redirect_to(url_for(controller: controller, action: :show, report_id: 69, id: model.last.id))
        end
      end

      describe 'PATCH' do
        let(:record) { create(model_symbol, report:old_report) }
        before { record }
        subject { patch "/reports/#{old_report.id}/#{model_symbol}s/#{record.id}", params: params }
        let(:params) { { model_symbol => record.attributes.merge({ report_id: 69 }) } }
        it 'redirects to new report' do
          is_expected.to redirect_to(url_for(controller: controller, action: :show, report_id: 69, id: record.id))
        end
      end
    end
  end
end
