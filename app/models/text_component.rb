class TextComponent < ActiveRecord::Base
   validates :heading, :main_part, presence: true
   has_many :conditions
   accepts_nested_attributes_for :conditions, reject_if: :all_blank, allow_destroy: true
   has_many :sensors, :through => :conditions
end
