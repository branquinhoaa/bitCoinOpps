class OpportunitiesController < ApplicationController
  before_action :set_opportunity, only: [:show, :destroy]

  # GET /todos
  def index
    @opportunities = Opportunity.all
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
  def set_opportunity
    @opportunity = Opportunity.find(params[:id])
  end
end
