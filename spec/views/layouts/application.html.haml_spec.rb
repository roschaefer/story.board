require 'rails_helper'

RSpec.describe "layouts/application", type: :view do
  context 'when logged in' do
    helper do
      def user_signed_in?
        true
      end

      def current_user
        FactoryGirl.build(:user, name: 'Hans Schwanitz')
      end
    end

    before do
      assign(:report , FactoryGirl.create(:report))
      assign(:subnav_items, [
        [
          {
            name: "First Level Item 1",
            url: "/ressource/1",
            active: false,
          },
          {
            name: "First Level Item 2",
            url: "ressource/2",
            active: true,
          },
          {
            name: "First Level Item 3",
            url: "ressource/3",
            active: true,
          }
        ], [
          {
            name: "Second Level Item 1",
            url: "/ressource/1/one",
            active: true
          },
          {
            name: "Second Level Item 2",
            url: "/ressource/2/two",
            active: false
          }
        ]
      ])

      assign(:primary_action, {
        name: 'Primary Call To Action',
        url: '/ressource/new'
      })

      assign(:secondary_actions, [
        {
          name: 'Secondary Action 1',
          url: '/do/this'
        }, {
          name: 'Secondary Action 2',
          url: '/and/that'
        }
      ])

    end
    
    let(:parsed) do
      render
      Capybara.string(rendered)
    end


    context 'renders a breadcrumb menu' do
      it 'has multiple levels' do
        expect(parsed).to have_css('.subnav__select', count: 2)
      end

      it 'has multiple select options with respective labels and urls' do
        expect(parsed).to have_css('.subnav__breadcrumb__item:nth-child(2) select option', count: 3)
        expect(parsed).to have_css('.subnav__breadcrumb__item:nth-child(3) select option', count: 2)

        expect(parsed).to have_css(
          '.subnav__breadcrumb__item:nth-child(2) select option:first-child[value="/ressource/1"]',
          text: 'First Level Item 1'
        )
      end
    end

  context 'renders an action button' do
    it 'has a single primary action' do
      expect(@parsed).to have_css(
        '.subnav__actions .btn-primary[href="/ressource/new"]',
        text: 'Primary Call To Action'
      )
    end

    it 'has multiple secondary actions' do
      expect(@parsed).to have_css('.subnav__actions select option', count: 3, visible: false)
    end
  end
end
