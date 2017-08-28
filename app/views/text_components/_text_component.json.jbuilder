json.extract! text_component, :id, :heading, :introduction, :main_part, :closing, :from_day, :to_day, :image_url, :image_alt
json.question_answers do
  json.array!(text_component.question_answers, partial: 'question_answers/question_answer', as: :question_answer)
end
json.url report_text_component_url(@report, text_component, format: :json)
