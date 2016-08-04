class Flight < ActiveRecord::Base
  validates :ident, presence: true
  belongs_to :user
end
