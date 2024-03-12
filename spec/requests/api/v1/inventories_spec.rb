# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/user/{user_id}/inventory/', type: :request do
  path '/api/v1/users/{user_id}/inventory/add_item' do
    parameter name: 'user_id', in: :path, type: :integer, description: 'user id'

    post 'Add items to inventory' do
      tags 'Inventory'
      consumes 'application/json'
      parameter name: :inventory, in: :body, schema: {
        type: :object,
        properties: {
          items: { type: :object },
          user_id: { type: :integer }
        },
        required: %w[items user_id]
      }

      let!(:user_id) { create(:user).id }

      response '201', 'water sucessfully added to inventory' do
        let(:items) {{ water: {quantity: 1} }}
        let(:inventory) { { items: items, user_id: user_id } }

        run_test! do |response|
          data = response.parsed_body['items']
          expect(data['water']['quantity']).to eq(1)
          expect(data['water']['points']).to eq(4)
        end
      end

      response '201', 'food sucessfully added to inventory' do
        let(:items) {{ food: {quantity: 1} }}
        let(:inventory) { { items: items, user_id: user_id } }

        run_test! do |response|
          data = response.parsed_body['items']
          expect(data['food']['quantity']).to eq(1)
          expect(data['food']['points']).to eq(3)
        end
      end

      response '201', 'medicine sucessfully added to inventory' do
        let(:items) {{ medicine: {quantity: 1} }}
        let(:inventory) { { items: items, user_id: user_id } }

        run_test! do |response|
          data = response.parsed_body['items']
          expect(data['medicine']['quantity']).to eq(1)
          expect(data['medicine']['points']).to eq(2)
        end
      end

      response '201', 'ammunition sucessfully added to inventory' do
        let(:items) {{ ammunition: {quantity: 1} }}
        let(:inventory) { { items: items, user_id: user_id } }

        run_test! do |response|
          data = response.parsed_body['items']
          expect(data['ammunition']['quantity']).to eq(1)
          expect(data['ammunition']['points']).to eq(1)
        end
      end

      response '201', 'water quantity sucessfully increased' do
        let(:items) {{ water: {quantity: 1} }}
        let(:inventory) { create(:inventory) }

        run_test!

        let(:another_quantity) { { items: items, user_id: user_id } }

        run_test! do |response|
          data = response.parsed_body['items']
          expect(data['water']['quantity']).to eq(2)
          expect(data['water']['points']).to eq(8)
        end
      end

      response '422', 'invalid request when item key is not permitted' do
        let(:items) {{ non_defined_item: {quantity: 1} }}
        let(:inventory) { { items: items, user_id: user_id } }

        run_test!
      end
    end
  end

  path '/api/v1/users/{user_id}/inventory/remove_item' do
    parameter name: 'user_id', in: :path, type: :integer, description: 'user id'

    post 'Remove items from inventory' do
      tags 'Inventory'
      consumes 'application/json'
      parameter name: :inventory, in: :body, schema: {
        type: :object,
        properties: {
          items: { type: :object },
          user_id: { type: :integer }
        },
        required: %w[items user_id]
      }

      let!(:user_id) { create(:user).id }

      response '200', 'water quantity sucessfully decreased' do
        let(:items) {{ 'water' => {'quantity' => 2} }}
        let(:inventory) { { 'items' => items, user_id: user_id } }

        before { post "/api/v1/users/#{user_id}/inventory/add_item", params: inventory }

        run_test! do |response|
          data = response.parsed_body['items']
          expect(data['water']['quantity']).to eq(0)
          expect(data['water']['points']).to eq(0)
        end
      end

      response '422', 'invalid request when item key is not permitted' do
        let(:items) {{ non_defined_item: {quantity: 1} }}
        let(:inventory) { { items: items, user_id: user_id } }

        run_test!
      end
    end
  end

  path '/api/v1/users/{user_id}/transfer_items/{target_user_id}' do
    parameter name: 'user_id', in: :path, type: :integer, description: 'user id'
    parameter name: 'target_user_id', in: :path, type: :integer, description: 'target user id'

    post 'Transfer items between users' do
      tags 'Inventory'
      consumes 'application/json'
      parameter name: :inventory, in: :body, schema: {
        type: :object,
        properties: {
          items: { type: :object },
          target_user_items: { type: :object },
          user_id: { type: :integer },
          target_user_id: { type: :integer }
        },
        required: %w[items user_id]
      }

      let!(:user_id) { create(:user).id }
      let!(:target_user_id) { create(:user).id }

      response '200', 'items sucessfully transfered' do
        let(:items) { { 'water' => { 'quantity' => 1 } } }
        let(:target_user_item) { { 'food' => { 'quantity' => 1 } } }
        let(:other_target_item) {{ 'ammunition' => { 'quantity' => 1 } }}
        let(:new_inventory_item) {{ 'food' => { 'quantity' => 1 }, 'ammunition' => { 'quantity' => 1 } }}
        let(:inventory_target) do
          { 'items' => target_user_item, user_id: target_user_id,  }
        end
        let(:other_inventory_target) do
          { 'items' => other_target_item, user_id: target_user_id }
        end

        let(:inventory) do
          { 'items' => items, 'target_user_items' => new_inventory_item, user_id: user_id, target_user_id: target_user_id }
        end

        before { post "/api/v1/users/#{user_id}/inventory/add_item", params: inventory }
        before { post "/api/v1/users/#{target_user_id}/inventory/add_item", params: inventory_target }
        before { post "/api/v1/users/#{target_user_id}/inventory/add_item", params: other_inventory_target }

        run_test! do |response|
          data = response.parsed_body
          expect(data['message']).to eq('Inventory items transferred successfully')
        end
      end

      response '422', 'invalid request when user does not have item' do
        let(:items) { { 'water' => { 'quantity' => 0 } } }
        let(:target_user_items) { { 'water' => { 'quantity' => 2 } } }
        let(:inventory) do
          { 'items' => items, 'target_user_items' => target_user_items, user_id:, target_user_id: }
        end

        run_test! do |response|
          expect(response.parsed_body['error']).to eq('User does not have enough items to transfer')
        end
      end
    end
  end
end
