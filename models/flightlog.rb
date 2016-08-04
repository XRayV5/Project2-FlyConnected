class Flightlog < ActiveRecord::Base
  validates :ident, presence: true
end
