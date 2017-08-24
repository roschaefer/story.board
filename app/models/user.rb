class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  validates :name, uniqueness: true, presence: true

  def self.default_scope
    order('LOWER("users"."name")')
  end
end
