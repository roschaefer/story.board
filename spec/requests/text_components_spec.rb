require 'rails_helper'

RSpec.describe "TextComponents", type: :request do
  let(:user) { create(:user) }
  before { sign_in user }
  let(:report) { create(:report, id: 4711) }
  describe "GET /text_components" do
    it "works! (now write some real specs)" do
      get report_text_components_path(report)
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /text_components" do
    it 'renders validation errors' do
      post '/reports/1/text_components', params: { text_component: { heading: nil }}
      parsed = Capybara.string(response.body)
      expect(parsed.find('.text-editor__field', text: 'Heading')).to have_text('can\'t be blank')
    end
  end

  describe "PATCH /text_components/:id" do
    it 'renders validation errors' do
      tc = create(:text_component)
      patch "/reports/1/text_components/#{tc.id}", params: { text_component: { heading: nil }}
      parsed = Capybara.string(response.body)
      expect(parsed.find('.text-editor__field', text: 'Heading')).to have_text('can\'t be blank')
    end
  end
end
