# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/users', type: :request do
  path '/api/v1/users' do
    post 'Creates a user' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          age: { type: :integer },
          gender: { type: :string },
          latitude: { type: :number, format: :float },
          longitude: { type: :number, format: :float }
        },
        required: %w[name age gender latitude longitude]
      }

      response '201', 'user created' do
        let(:user) { create(:user) }

        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { { name: 'test-user', age: 30, gender: 'male' } }

        run_test!
      end
    end
  end

  path '/api/v1/users/{id}' do
    parameter name: 'id', in: :path, type: :integer, description: 'id'

    put 'Updates a user location' do
      tags 'Users'
      consumes 'application/json'
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          latitude: { type: :number, format: :float },
          longitude: { type: :number, format: :float }
        }
      }

      response '204', 'user location updated' do
        let(:id) { create(:user).id }
        let(:user) { { latitude: 1234, longitude: 5678 } }

        run_test!
      end

      response '404', 'user not found' do
        let(:id) { -1 }
        let(:user) { { latitude: 1234, longitude: 5678 } }

        run_test!
      end
    end
  end
end
