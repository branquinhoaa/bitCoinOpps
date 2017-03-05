# frozen_string_literal: true
class Bid < ApplicationRecord
  belongs_to :opportunity

  validates :exchange, presence: true
  validates :value, presence: true
end
