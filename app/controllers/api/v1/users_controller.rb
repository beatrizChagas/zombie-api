# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      # POST /api/v1/users
      # Creates a new user
      def create
        @user = User.new(user_params)

        if @user.save
          render json: UserBlueprint.render(@user), status: :created
        else
          render @user.errors, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/users/:id
      # Updates a user
      def update
        @user = User.find(params[:id])

        @user.update(user_params)

        head :no_content
      end

      private

      def user_params
        params.permit(:name, :age, :gender, :latitude, :longitude)
      end
    end
  end
end
