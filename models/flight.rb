class Flight < ActiveRecord::Base
  validates :ident, presence: true
end
