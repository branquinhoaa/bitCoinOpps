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

      context 'when the request is valid' do
        before do
          mocked_kraken = double
          allow(mocked_kraken).to receive(:public).and_return(mocked_kraken)
          allow(mocked_kraken).to receive(:order_book).with('XXBTZUSD').and_return({"XXBTZUSD" => {
            "asks" => [ [ "1500", "1.537", 1488568657 ], [ "1200", "1.234", 1488568658]],
            "bids" => [ [ "1500", "1.537", 1488568659 ], [ "1200", "1.234", 1488568660]]}})

          allow(KrakenClient).to receive(:load).and_return(mocked_kraken)

          mocked_bcte = double
          allow(mocked_bcte).to receive(:json).and_return({"btc_usd" => {
            "asks" => [[1151, 2.148485],[1351, 0.016032]],
            "bids" => [[900, 2.148485],[1200, 0.016032]]
            }})
          allow(Btce::Depth).to receive(:new).with("btc_usd").and_return(mocked_bcte)
          post '/opportunities'
        end

        it 'creates an opportunity' do
          expect(json['id']).to_not be_nil
        end

        describe 'creates an opportunity' do
          it 'with a largest bid' do
            expect(json['bid']['value']).to eq(1500)
          end
          it 'with an lowest ask' do
            expect(json['ask']['value']).to eq(1151.0)
          end
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
