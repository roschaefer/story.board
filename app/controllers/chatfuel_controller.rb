class ChatfuelController < ApplicationController
  def show
    @report = Report.find_by_id(params[:report_id])
    if @report
      @topic = Topic.find_by(name: params[:topic])
      if @topic
        relevant_text_components = @report.active_chatbot_components.select {|c| c.topic_id == @topic.id}
        @text_component = Text::Sorter.sort(relevant_text_components, {}).first

        if @text_component
          @next_question_answer = @text_component.question_answers.first
          render json: json_response
        else
          render json: {}, status: 404
        end
      else
        render json: {}, status: 404
      end
    else
      render json: {}, status: 404
    end
  end

  def answer_to_question
    @text_component = TextComponent.includes(:question_answers).find(params[:text_component_id])
    @topic = @text_component.topic
    index = params[:index].to_i - 1
    @question_answer = @text_component.question_answers[index]
    if @question_answer && @topic
      @next_question_answer = @text_component.question_answers[index + 1]
      render json: json_response
    else
      render json: {}, status: 404
    end
  end

  private

  def json_response
    if @question_answer
      text = Text::Renderer.new(text_component: @text_component).render_string(@question_answer.answer)
    else
      text = Text::Renderer.new(text_component: @text_component).render(:main_part)
    end

    content = text.first(640);

    if @next_question_answer
      {
        messages: [
            {
            attachment: {
              payload: {
                template_type: "button",
                text: "#{content}",
                buttons: [
                  {
                    url: answer_to_question_url(text_component_id: @text_component, index: @text_component.question_answers.index(@next_question_answer) + 1),
                    type: "json_plugin_url",
                    title: @next_question_answer.question
                  }
              ]
              },
              type: "template"
            }
          }
        ]
      }
    elsif @question_answer && !@next_question_answer
      {
        messages: [
            { text: content.first(640) }
        ],
        redirect_to_blocks: ["continue_" + @topic.name + "_" + @report.id.to_s]
      }
    else
      {
        messages: [
          { text: content.first(640) } # Messages for Facebook Messenger can only be 640 characters long. Source: https://developers.facebook.com/docs/messenger-platform/send-api-reference#request
        ]
      }
    end
  end
end
