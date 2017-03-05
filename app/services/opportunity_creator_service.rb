class OpportunityCreatorService
  def create_opportunity
    opportunity = Opportunity.new
    opportunity.bid = largest_bid
    opportunity.ask = lowest_ask
    opportunity
  end

  private

  def lowest_ask
    kraken =  KRAKEN.DataFetcher.get_kraken_data
    btce = BTCE.DataFetcher.get_btce_data

    lowest_kraken = kraken['XXBTZUSD']['asks'].min_by{ |order| order[0] } #return value, amount, id
    lowest_btce = btce.json["btc_usd"]["asks"].min_by{ |order| order[0] } #return value, amount

    #build the ask object with the lowest ask value:
    if lowest_kraken[0].to_f < lowest_btce[0]
      Ask.new(exchange: 'kraken', value: lowest_kraken[0].to_f)
    else
      Ask.new(exchange: 'btce', value: lowest_btce[0])
    end
  end

  def largest_bid
    kraken = KRAKEN.DataFetcher.get_kraken_data
    btce = BTCE.DataFetcher.get_btce_data
    higher_kraken = kraken['XXBTZUSD']["bids"].max_by{ |order| order[0] } #here I choose the best kraken bid (more expensive)
    higher_btce = btce.json["btc_usd"]["bids"].max_by{ |order| order[0] } #return value, amount

    #build the bid object with the highest bid value
    if higher_kraken[0].to_f > higher_btce[0]
      Bid.new(exchange: 'kraken', value: higher_kraken[0].to_f)
    else
      Bid.new(exchange: 'btce', value: higher_btce[0])
    end
  end
end
