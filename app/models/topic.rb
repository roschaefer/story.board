class Topic < ActiveRecord::Base
  enum channel: [ :website, :chatfuel]
  has_many :text_components
end
