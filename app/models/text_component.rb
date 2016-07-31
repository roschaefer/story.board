class TextComponent < ActiveRecord::Base
  belongs_to :report
  has_many :sensors, through: :conditions
  has_many :conditions

  validates :heading, :main_part, presence: true
  validates :report, presence: true
  accepts_nested_attributes_for :conditions, reject_if: :all_blank, allow_destroy: true

  enum priority: [ :low, :medium, :high]
  after_initialize :set_defaults, unless: :persisted?

  def set_defaults
    self.priority ||= :medium
  end

  def active?(intention = :real)
    conditions.all? do |condition|
      value = condition.last_value(intention)
      value && condition.from <= value && value <= condition.to
    end
  end
end
