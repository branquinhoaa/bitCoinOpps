# frozen_string_literal: true
class OpportunitiesController < ApplicationController
  before_action :set_opportunity, only: [:show, :destroy]

  # GET /opportunities
  def index
    @opportunities = Opportunity.all
    json_response(@opportunities)
  end

  # POST /opportunities
  def create
    @opportunity = OpportunityCreatorService.new.create_opportunity
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

  def set_opportunity
    @opportunity = Opportunity.find(params[:id])
  end
end
