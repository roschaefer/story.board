class ChatfuelController < ApplicationController
  def show
    chatbot_channel = Channel.find_by(name: "chatbot", report: Report.current)

    tc = Text::Sorter.sort(chatbot_channel.text_components, {}).first

    if tc
      text = Text::Renderer.new(text_component: tc).render(:main_part)

      @response = {
        messages: [
          { text: text.first(640)} # Messages for Facebook Messenger can only be 640 characters long. Source: https://developers.facebook.com/docs/messenger-platform/send-api-reference#request
        ]
      }
      render json: @response
    else
      render json: {}, status: 404
    end
  end
end
