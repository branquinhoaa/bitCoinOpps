class Bid < ApplicationRecord
  belongs_to :opportunity

  validates_presence_of :exchange
  validates_presence_of :value
end
