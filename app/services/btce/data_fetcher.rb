require 'btce'

module BTCE
  class DataFetcher
    def self.get_btce_data
      Btce::Depth.new "btc_usd"   #This method provides the information about active orders on the pair.
    end
  end
end
