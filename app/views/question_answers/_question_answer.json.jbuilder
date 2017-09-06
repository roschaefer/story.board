json.extract! question_answer, :id, :text_component_id
json.question question_answer.rendered_question(@diary_entry)
json.answer question_answer.rendered_answer(@diary_entry)