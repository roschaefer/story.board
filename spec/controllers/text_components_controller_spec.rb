require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe TextComponentsController, type: :controller do
  login_user

  # This should return the minimal set of attributes required to create a valid
  # TextComponent. As you add validations to TextComponent, be sure to
  # adjust the attributes here as well.
  let(:report) { create(:report) }
  let(:channel) { create(:channel) }
  let(:valid_attributes) {
    { heading: 'A heading', report_id: report.id, channel_ids: [channel.id] }
  }

  let(:invalid_attributes) {
    { heading: nil  }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # TextComponentsController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all text_components as @text_components" do
      text_component = create(:text_component, valid_attributes)
      get :index, params: {}, session: valid_session
      expect(assigns(:text_components)).to eq([text_component])
    end

    context 'more than one text component for a trigger' do
      it 'yields all the components of a trigger', issue: 375 do
        trigger = create(:trigger, name: 'trigger_name')
        text_components = create_list(:text_component, 2, triggers: [trigger])
        get :index, params: {}, session: valid_session
        expect(assigns(:trigger_groups)).to eq({'trigger_name' => text_components})
      end
    end
  end

  describe "GET #show" do
    it "assigns the requested text_component as @text_component" do
      text_component = create(:text_component, valid_attributes)
      get :show, params: {:id => text_component.to_param}, session: valid_session
      expect(assigns(:text_component)).to eq(text_component)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new TextComponent" do
        expect {
          post :create, params: {:text_component => valid_attributes}, session: valid_session
        }.to change(TextComponent, :count).by(1)
      end

      it "assigns a newly created text_component as @text_component" do
        post :create, params: {:text_component => valid_attributes}, session: valid_session
        expect(assigns(:text_component)).to be_a(TextComponent)
        expect(assigns(:text_component)).to be_persisted
      end

      it "redirects to the created text_component" do
        post :create, params: {:text_component => valid_attributes}, session: valid_session
        expect(response).to redirect_to(TextComponent.last)
      end

      describe 'with a new trigger' do
        it 'assigns the report for the trigger, if missing' do
          attributes = valid_attributes.merge(triggers_attributes: [{name: 'Trigger name', report_id: nil}])
          expect {
            post :create, params: {text_component: attributes}, session: valid_session
          }.to change(Trigger, :count).by(1)
        end
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved text_component as @text_component" do
        post :create, params: {:text_component => invalid_attributes}, session: valid_session
        expect(assigns(:text_component)).to be_a_new(TextComponent)
      end

      it "re-renders the 'index' template" do
        post :create, params: {:text_component => invalid_attributes}, session: valid_session
        expect(response).to render_template("index")
      end
    end
  end

  describe "PUT #update" do
    context 'attributes for question/answers' do
      describe '_destroy' do
        let(:text_component) { create(:text_component, question_answers: [question_answer]) }
        let(:question_answer) { create(:question_answer) }
        let(:question_answers_attributes) {
          [ { id: question_answer.id, _destroy: 1 } ]
        }

        it "destroys associated question/answers" do
          expect(text_component.question_answers).not_to be_empty
          put :update, params: {:id => text_component.id, text_component: { question_answers_attributes: question_answers_attributes } }, session: valid_session
          text_component.reload
          expect(text_component.question_answers).to be_empty
        end
      end
    end

    context "with valid params" do
      let(:new_attributes) {
        { heading: 'A new heading', main_part: 'Plus a main part' }
      }

      it "updates the requested text_component" do
        text_component = create(:text_component, valid_attributes)
        put :update, params: {:id => text_component.to_param, :text_component => new_attributes}, session: valid_session
        text_component.reload
        expect(text_component.heading).to eq 'A new heading'
        expect(text_component.main_part).to eq 'Plus a main part'
      end

      it "assigns the requested text_component as @text_component" do
        text_component = create(:text_component, valid_attributes)
        put :update, params: {:id => text_component.to_param, :text_component => valid_attributes}, session: valid_session
        expect(assigns(:text_component)).to eq(text_component)
      end

      it "redirects to the text_component" do
        text_component = create(:text_component, valid_attributes)
        put :update, params: {:id => text_component.to_param, :text_component => valid_attributes}, session: valid_session
        expect(response).to redirect_to(text_component)
      end
    end

    context "with invalid params" do
      it "assigns the text_component as @text_component" do
        text_component = create(:text_component, valid_attributes)
        put :update, params: {:id => text_component.to_param, :text_component => invalid_attributes}, session: valid_session
        expect(assigns(:text_component)).to eq(text_component)
      end

      it "re-renders the 'index' template" do
        text_component = create(:text_component, valid_attributes)
        put :update, params: {:id => text_component.to_param, :text_component => invalid_attributes}, session: valid_session
        expect(response).to render_template("index")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested text_component" do
      text_component = create(:text_component, valid_attributes)
      expect {
        delete :destroy, params: {:id => text_component.to_param}, session: valid_session
      }.to change(TextComponent, :count).by(-1)
    end

    it "redirects to the text_components list" do
      text_component = create(:text_component, valid_attributes)
      delete :destroy, params: {:id => text_component.to_param}, session: valid_session
      expect(response).to redirect_to(text_components_url)
    end
  end

end
