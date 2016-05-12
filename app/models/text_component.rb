class TextComponent < ActiveRecord::Base
   validates :heading, :main_part, presence: true
end
