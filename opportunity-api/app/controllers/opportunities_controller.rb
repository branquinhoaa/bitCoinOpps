class OpportunitiesController < ApplicationController
  before_action :set_opportunity, only: [:show, :destroy]

  # GET /todos
  def index
    @opportunities = Opportunity.all
lowest_ask
    json_response(@opportunities)
  end

  # POST /todos
  def create
    @opportunity = Opportunity.new
    @opportunity.bid=Bid.new(exchange: 'one', value: 255)
    @opportunity.ask=Ask.new(exchange: 'two', value: 255)
    if @opportunity.save!
      json_response(@opportunity, :created)
    else
      json_response({ message: e.message }, :unprocessable_entity)
    end
  end

  # GET /todos/:id
  def show
    json_response(@opportunity)
  end

  # DELETE /todos/:id
  def destroy
    @opportunity.destroy
    head :no_content
  end

  private

  def get_kraken_data
    client = KrakenClient.load
    # data will have value, amount, id - in this order
    data = client.public.order_book('XXBTZUSD') # this is the code for USD BTC
  end

  def get_btce_data
  end
  
  def lowest_ask
    kraken =  get_kraken_data
    kraken_asks = kraken['XXBTZUSD']['asks'] #here I get all the asks
    lowest_kraken = kraken_asks.min_by{ |order| order[0] } #here I choose the best kraken ask (cheaper)
    byebug
    Ask.new(exchange: 'two', value: 255) #build the ask object with the lowest ask value
  end

  def largest_bid
    kraken = get_kraken_data
    kraken_bids = kraken['XXBTZUSD']['bids'] #here I get all bids
    larger_bid = kraken_bids.max_by{ |order| order[0] } #here I choose the best kraken bid (more expensive)
    Bid.new(exchange: 'one', value: 255) #build the bid object with the highest bid value
  end


  def set_opportunity
    @opportunity = Opportunity.find(params[:id])
  end
end
