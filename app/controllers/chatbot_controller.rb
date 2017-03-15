class ChatbotController < ApplicationController
  def show
    # TODO order by priority and maybe have a fallback
    chatbot_channel = Channel.find_by(name: "chatbot")
    current_report = Report.current
    tc = TextComponent
      .where(report: current_report)
      .where(topic: Topic.find_by(name: params[:topic]))
      .joins(:channels)
      .where("channels.id = :channel_id", {channel_id: chatbot_channel.id})
      .first

    @response = {
      messages: [
        { text: tc.main_part.first(640)} # Messages for Facebook Messenger can only be 640 characters long. Source: https://developers.facebook.com/docs/messenger-platform/send-api-reference#request
      ]
    }
    render json: @response
  end
end
