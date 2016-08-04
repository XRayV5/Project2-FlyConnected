class User < ActiveRecord::Base
  validates :email, :password_digest, presence: true
  has_secure_password
  has_many :routes
  has_many :flights
  has_many :tags
  has_many :airports, through: :tags
end
