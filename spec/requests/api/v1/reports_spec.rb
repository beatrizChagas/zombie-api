# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/report/', type: :request do
  path '/api/v1/report/infected_users' do
    get 'Infected users percentage' do
      tags 'Report'
      consumes 'application/json'

      response '200', 'returns 0.0% users infected' do
        let(:user) { create(:user) }
        before { get '/api/v1/report/infected_users', params: user }

        run_test! do |response|
          data = response.parsed_body

          expect(data).to eq('Percentage' => 0.0)
        end
      end

      response '404', 'user not found' do
        run_test!
      end
    end
  end

  path '/api/v1/report/non_infected_users' do
    get 'Non-Infected users percentage' do
      tags 'Report'
      consumes 'application/json'

      response '200', 'returns 100.0% non-infected users' do
        let(:user) { create(:user) }
        before { get '/api/v1/report/non_infected_users', params: user }

        run_test! do |response|
          data = response.parsed_body

          expect(data).to eq('Percentage' => 100.0)
        end
      end

      response '404', 'user not found' do
        run_test!
      end
    end
  end

  path '/api/v1/report/item_average_per_user' do
    get 'Average items per user' do
      tags 'Report'
      consumes 'application/json'

      response '200', 'average items users' do
        let(:user) { create(:user) }

        let(:items) { { 'water' => { 'quantity' => 2 } } }
        let(:inventory) { { 'items' => items, user_id: user.id } }

        before { post "/api/v1/users/#{user.id}/inventory/add_item", params: inventory }
        before { get '/api/v1/report/item_average_per_user', params: user }

        run_test! do |response|
          data = response.parsed_body

          expect(data).to eq('Items average' => { 'ammunition' => 0.0, 'food' => 0.0, 'medicine' => 0.0,
                                                  'water' => 2.0 })
        end
      end

      response '404', 'user not found' do
        run_test!
      end
    end
  end
end
