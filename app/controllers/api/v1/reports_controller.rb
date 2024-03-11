# frozen_string_literal: true

module Api
  module V1
    class ReportsController < ApplicationController
      # GET report/infected_users
      def infected_users
        users = User.count
        infected_user_count = Infection.infected_users_count

        if users > 0
          percentage = (infected_user_count / users) * 100

          render json: { percentage: percentage }, status: :ok
        else
          render json: { error: 'No users found' }, status: :not_found
        end
      end
    end
  end
end
