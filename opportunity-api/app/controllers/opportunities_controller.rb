class OpportunitiesController < ApplicationController
  before_action :set_opportunity, only: [:show, :destroy]

  # GET /opportunities
  def index
    @opportunities = Opportunity.all
    json_response(@opportunities)
  end

  # POST /opportunities
  def create
    @opportunity = Opportunity.new
    @opportunity.bid = largest_bid
    @opportunity.ask = lowest_ask
    if @opportunity.save!
      json_response(@opportunity, :created)
    else
      json_response({ message: e.message }, :unprocessable_entity)
    end
  end

  # GET /opportunities/:id
  def show
    json_response(@opportunity)
  end

  # DELETE /opportunities/:id
  def destroy
    @opportunity.destroy
    head :no_content
  end

  private

  def get_kraken_data
    client = KrakenClient.load
    data = client.public.order_book('XXBTZUSD') # this is the code for USD BTC
  end

  def get_btce_data
    require 'btce'
    Btce::Depth.new "btc_usd"   #This method provides the information about active orders on the pair.
  end

  def lowest_ask
    kraken =  get_kraken_data
    btce = get_btce_data

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
    kraken = get_kraken_data
    btce = get_btce_data

    higher_kraken = kraken['XXBTZUSD']['bids'].max_by{ |order| order[0] } #here I choose the best kraken bid (more expensive)
    higher_btce = btce.json["btc_usd"]["bids"].max_by{ |order| order[0] } #return value, amount

    #build the bid object with the highest bid value
    if higher_kraken[0].to_f > higher_btce[0]
      Bid.new(exchange: 'kraken', value: higher_kraken[0].to_f)
    else
      Bid.new(exchange: 'btce', value: higher_btce[0])
    end
  end


  def set_opportunity
    @opportunity = Opportunity.find(params[:id])
  end
end
