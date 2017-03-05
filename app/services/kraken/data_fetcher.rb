module KRAKEN
  class DataFetcher
    def get_kraken_data
      client = KrakenClient.load
      data = client.public.order_book('XXBTZUSD') # this is the code for USD BTC
    end
  end
end
