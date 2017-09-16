require 'rails_helper'
require 'capybara/rspec'

RSpec.describe "text_components/index", type: :view do
  let(:report) { create(:report, name: 'UniqueReportName') }
  let(:diary_entry) { create(:diary_entry, report: report, moment: Time.zone.now)}
  let(:trigger) { create(:trigger) }
  let(:channel_sensorstory) { create(:channel, name: 'sensorstory') }
  let(:channel_chatbot) { create(:channel, name: 'chatbot') }
  let(:text_components) do
    [create(
        :text_component,
        :heading => "Text Component 1 (Channels: Sensorstory)",
        :report_id => report.id,
        :channel_ids => [1],
        :publication_status => 0,
        :from_day => 1,
        :to_day => 2
      ),
      create(
        :text_component,
        :heading => "Text Component 2 (Channels: Sensorstory, Chatbot)",
        :report_id => report.id,
        :channel_ids => [1, 2],
        :publication_status => 2,
        :from_day => 1,
        :to_day => 2
      )]
  end

  before(:each) do
    assign(:report, report)
    assign(:diary_entry, diary_entry)
    assign(:text_component, TextComponent.new)
    new_text_component = TextComponent.new
    new_text_component.triggers.build
    assign(:new_text_component, new_text_component)
    assign(:sensors, [
      create(
        :sensor,
        :name => "Sensor Name",
      )
    ])
    assign(:events, [
      create(
        :event,
        :name => "Event Name",
      )
    ])
    assign(:filter, {})
    assign(:trigger_groups, [trigger] => text_components.map{ |tc| TextComponentDecorator.new(tc, diary_entry) })
  end

  context "render a list of text_components" do

    it "shows the text component heading" do
      render
      assert_select ".item-table__item td", :text => "Text Component 1 (Channels: Sensorstory)", :count => 1
      assert_select ".item-table__item td", :text => "Text Component 2 (Channels: Sensorstory, Chatbot)", :count => 1
    end

    it "shows from and to days" do
      render
      assert_select ".item-table__item td", :text => "1 – 2\n\nalways", :count => 2
    end

    it "indicates the publication status" do
      render
      assert_select ".item-table__channels .text-primary", :count => 1
      assert_select ".item-table__channels .text-success", :count => 1
    end

    it "indicates each text_component's channels" do
      render
      assert_select ".item-table__channels .fa-file-text", :count => 1
      assert_select ".item-table__channels .fa-ellipsis-h", :count => 1
    end
  end

end
