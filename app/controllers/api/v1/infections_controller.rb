# frozen_string_literal: true

module Api
  module V1
    class InfectionsController < ApplicationController
      # POST users/:user_id/infection
      def create
        @infection = Infection.new(infection_params)

        if @infection.save
          render json: InfectionBlueprint.render(@infection), status: :created
        else
          render @infection.errors, status: :unprocessable_entity
        end
      end

      private

      def infection_params
        params.permit(:user_id, :infected_user_id)
      end
    end
  end
end
