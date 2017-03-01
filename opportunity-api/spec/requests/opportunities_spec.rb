require 'rails_helper'

RSpec.describe 'Opportunity API', type: :request do
  # initialize test data
  let!(:opportunities) { create_list(:opportunity, 10) }
  let(:opportunity_id) { opportunities.first.id }

  # Test suite for GET /opportunity
  describe 'GET /opportunities' do
    # make HTTP get request before each example
    before { get '/opportunities' }

    it 'returns opportunities' do
      # Note `json` is a custom helper to parse JSON responses
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  # Test suite for GET /opportunities/:id
  describe 'GET /opportunities/:id' do
    before { get "/opportunities/#{opportunity_id}" }

    context 'when the record exists' do
      it 'returns the opportunity' do
        expect(json).not_to be_empty
        expect(json['id']).to eq(opportunity_id)
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the record does not exist' do
      let(:opportunity_id) { 100 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end


    # Test suite for POST /opportunities
    describe 'POST /opportunities' do
      # valid payload
      let(:valid_attributes) { { } }

      context 'when the request is valid' do
        before { post '/opportunities', params: valid_attributes }

        it 'creates a opportunity' do
          expect(json['bid']['value']).to eq(255)
          expect(json['ask']['value']).to eq(255)
        end

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end
      end
    end

    # Test suite for DELETE /opportunities/:id
   describe 'DELETE /opportunities/:id' do
     before { delete "/opportunities/#{opportunity_id}" }

     it 'returns status code 204' do
       expect(response).to have_http_status(204)
     end
   end

end