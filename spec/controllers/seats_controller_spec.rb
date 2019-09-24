require 'rails_helper'
RSpec.describe 'Test Seat Arrangment Request', type: :request do
  # Test for POST /api/v1/seats
  describe 'POST /api/v1/seats' do

    context '#check valid request' do
      before { post '/api/v1/seats', params: { array: '[[3,2], [4,3], [2,3], [3,4]]', passenger_no: '30'} }

      it 'post seat arragnment request' do
        json = JSON.parse(response.body)
        expect(json)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end
    end

  end
end