# frozen_string_literal: true
module KRAKEN
  class DataFetcher
    def initialize
      client = KrakenClient.load
      @data = client.public.order_book('XXBTZUSD') # this is the code for USD BTC
    end

    def bids
      @data['XXBTZUSD']['bids']
    end

    def asks
      @data['XXBTZUSD']['asks']
    end
  end
end
