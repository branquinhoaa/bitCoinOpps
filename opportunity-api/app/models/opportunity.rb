class Opportunity < ApplicationRecord
  has_one :bid, dependent: :destroy
  has_one :ask, dependent: :destroy
end
