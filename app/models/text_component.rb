class TextComponent < ActiveRecord::Base
  validates :heading, presence: true
  has_and_belongs_to_many :triggers
  has_many :sensors, through: :triggers
  has_many :events, through: :triggers
  belongs_to :report


  def active?(opts={})
    triggers.all? {|t| t.active?(opts) }
  end
end
