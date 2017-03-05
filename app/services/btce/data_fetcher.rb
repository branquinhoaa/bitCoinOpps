# frozen_string_literal: true
require 'btce'
module BTCE
  class DataFetcher
    def initialize
      @data = Btce::Depth.new 'btc_usd' # This method provides the information about active orders on the pair.
    end

    def asks
      @data.json['btc_usd']['asks'] # return value, amount
    end

    def bids
      @data.json['btc_usd']['bids'] # return value, amount
    end
  end
end
