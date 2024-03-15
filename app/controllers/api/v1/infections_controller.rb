# frozen_string_literal: true

module Api
  module V1
    class InfectionsController < ApplicationController
      include JsonResponse

      # POST /api/v1/users/:user_id/infection
      # Reports an infected user
      def create
        @infection = Infection.new(infection_params)

        if @infection.save
          render_blueprint(InfectionBlueprint, @infection, :created)
        else
          render_error(@infection.errors, :unprocessable_entity)
        end
      end

      private

      def infection_params
        params.permit(:user_id, :infected_user_id)
      end
    end
  end
end
