class ChatbotController < ApplicationController
  def show
    # TODO order by priority and maybe have a fallback
    chatbot_channel = Channel.find_by(name: "chatbot", report: Report.current)

    tc = chatbot_channel
      .text_components
      .where(topic: Topic.find_by(name: params[:topic]))
      .select(&:active?)
      .tap{|tcs| puts tcs.map(&:triggers).inspect}
      .select(&:priority_raw)
      .sort_by(&:priority_raw)
      .reverse
      .first

    @response = {
      messages: [
        { text: tc.main_part.first(640)} # Messages for Facebook Messenger can only be 640 characters long. Source: https://developers.facebook.com/docs/messenger-platform/send-api-reference#request
      ]
    }
    render json: @response
  end
end
