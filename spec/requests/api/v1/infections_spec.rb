# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/infections', type: :request do
  path '/api/v1/users/{user_id}/infection' do
    parameter name: 'user_id', in: :path, type: :integer, description: 'id'

    post 'Reports an infected user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :infection, in: :body, schema: {
        type: :object,
        properties: {
          user_id: { type: :integer },
          infected_user_id: { type: :integer }
        },
        required: %w[user_id infected_user_id]
      }

      response '201', 'infection reported' do
        let(:user_id) { create(:user).id }
        let(:infected_user_id) { create(:user).id }
        let(:infection) { { user_id:, infected_user_id: } }

        run_test!
      end

      response '422', 'invalid request when user does not exist' do
        let(:user_id) { 0 }
        let(:infection) { { user_id:, infected_user_id: -1 } }

        run_test!
      end

      response '422', 'invalid request when reported user does not exist' do
        let(:user_id) { create(:user).id }
        let(:infection) { { user_id:, infected_user_id: -1 } }

        run_test!
      end
    end
  end
end
