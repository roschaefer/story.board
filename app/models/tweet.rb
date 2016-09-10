class Tweet < ActiveRecord::Base
  validates :user, presence: true
end
