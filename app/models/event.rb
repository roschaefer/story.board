class Event < ActiveRecord::Base
  has_and_belongs_to_many :text_components
  validates :name, presence: true, uniqueness: true

  def happened?
    ! happened_at.nil?
  end

  def name_and_id
    "#{name} (#{id})"
  end
end
