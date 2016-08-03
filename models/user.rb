class User < ActiveRecord::Base
  validates :email, :password_digest, presence: true
  has_secure_password
end
