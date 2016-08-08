class Variable < ActiveRecord::Base
  validates :key, presence: true, uniqueness: true
  belongs_to :report
end
