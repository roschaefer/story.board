class Channel < ActiveRecord::Base
  has_and_belongs_to_many :text_components
  belongs_to :report
end
