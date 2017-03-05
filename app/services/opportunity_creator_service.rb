# frozen_string_literal: true
class OpportunityCreatorService
  def initialize
    @data = initialize_data
  end

  def create_opportunity
    opportunity = Opportunity.new
    opportunity.bid = largest_bid
    opportunity.ask = lowest_ask
    opportunity
  end

  private

  def initialize_data
    {
      kraken: KRAKEN::DataFetcher.new,
      btce: BTCE::DataFetcher.new
    }
  end

  def lowest_ask
    lowest_ask = @data.collect do |exchange, exchange_data|
      {
        exchange: exchange,
        order: exchange_data.asks.min_by { |order| order_value(order) }
      }
    end
    lowest_ask.min_by do |order|
      order_value(order[:order])
    end

    Ask.new(exchange: lowest_ask[:exchange], value: order_value(lowest_ask[:order]))
  end

  def largest_bid
    highest_bid = @data.collect do |exchange, exchange_data|
      {
        exchange: exchange,
        order: exchange_data.bids.max_by { |order| order_value(order) }
      }
    end
    highest_bid.max_by do |order|
      order_value(order[:order])
    end

    Bid.new(exchange: highest_bid[:exchange], value: order_value(highest_bid[:order]))
  end

  # order is an array with: [value, amount, (id)?]
  def order_value(order)
    order[0].to_f
  end
end
