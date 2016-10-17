class TextComponent < ActiveRecord::Base
  validates :heading, presence: true
  has_and_belongs_to_many :triggers
  belongs_to :report


  def active?
    triggers.all? {|t| t.active? }
  end
end
