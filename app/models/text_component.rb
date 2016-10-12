class TextComponent < ActiveRecord::Base
  validates :heading, presence: true
end
