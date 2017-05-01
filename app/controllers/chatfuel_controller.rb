class ChatfuelController < ApplicationController
  def show
    chatbot_channel = Channel.chatbot

    @text_component = Text::Sorter.sort(chatbot_channel.text_components, {}).first

    if @text_component
      @next_question_answer = @text_component.question_answers.first
      render json: json_response
    else
      render json: {}, status: 404
    end
  end

  def answer_to_question
    @text_component = TextComponent.includes(:question_answers).find(params[:text_component_id])
    index = params[:index].to_i
    @question_answer = @text_component.question_answers[index]
    @next_question_answer = nil # TODO: implement
    render json: json_response
  end

  private

  def json_response
    if @text_component
      text = Text::Renderer.new(text_component: @text_component).render(:main_part)
      messages =  [
        { text: text.first(640)} # Messages for Facebook Messenger can only be 640 characters long. Source: https://developers.facebook.com/docs/messenger-platform/send-api-reference#request
      ]
    end

    if @question_answer
      messages << {
        text: @question_answer.answer
      }
    end

    if @next_question_answer
      messages <<  {
        attachment: {
          payload: {
            template_type: "button",
            text: "I have actually no idea how Chatfuel renders this part. Is it some text up front to the button?",
            buttons: [
              {
                url: answer_to_question_url(text_component_id: @text_component, index: @text_components.question_answers.index(@next_question_answer)),
                type: "json_plugin_url",
                title: @next_question_answer.question
              }
          ]
          },
          type: "template"
        }
      }
    end

    # return this hash
    {
      messages: messages
    }

  end
end
