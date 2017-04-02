class CreateQuestionAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :question_answers do |t|
      t.text :question
      t.text :answer
      t.references :text_component, foreign_key: true

      t.timestamps
    end
  end
end
