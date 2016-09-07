class Event < ActiveRecord::Base
  has_and_belongs_to_many :text_components

  def happened?
    ! happened_at.nil?
  end
end
