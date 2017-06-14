class QuestionAnswer < ApplicationRecord
  default_scope { order(created_at: :asc) }

  belongs_to :text_component

  validates :question, length: { maximum: 640 }
  validates :answer, length: { maximum: 640 }

  [:question, :answer].each do |attribute|
    define_method "rendered_#{attribute}" do |opts|
      string = self.send(attribute)
      renderer = Text::Renderer.new(text_component: self.text_component, opts: opts) 
      renderer.render_string(string)
    end
  end
end
