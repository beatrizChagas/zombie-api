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
        required: ['name', 'age', 'gender', 'latitude', 'longitude']
      }

      response '201', 'user created' do
        let(:user) { create(:user) }
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) {{ name: 'test-user', age: 30, gender: 'male' }}
        run_test!
      end
    end
  end
end
