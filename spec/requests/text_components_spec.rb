require 'rails_helper'

RSpec.describe "TextComponents", type: :request do
  let(:user) { create(:user) }
  before { sign_in user }

  describe "GET /text_components" do
    it "works! (now write some real specs)" do
      get text_components_path
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /text_components" do
    it 'renders validation errors' do
      post '/text_components', params: { text_component: { heading: nil }}
      expect(response.body).to include("Heading can't be blank")
    end
  end

  describe "PATCH /text_components/:id" do
    it 'renders validation errors' do
      tc = create(:text_component)
      patch "/text_components/#{tc.id}", params: { text_component: { heading: nil }}
      expect(response.body).to include("Heading can't be blank")
    end
  end
end
