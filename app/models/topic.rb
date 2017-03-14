class Topic < ActiveRecord::Base
  has_many :text_components
end
