class TextComponent < ActiveRecord::Base
  validates :heading, presence: true
  has_and_belongs_to_many :triggers
end
