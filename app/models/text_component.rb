class TextComponent < ActiveRecord::Base
  belongs_to :report
  has_many :sensors, through: :conditions
  has_many :conditions

  validates :heading, :main_part, presence: true
  validates :report, presence: true
  accepts_nested_attributes_for :conditions, reject_if: :all_blank, allow_destroy: true
end
