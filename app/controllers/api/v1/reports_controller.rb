# frozen_string_literal: true

module Api
  module V1
    class ReportsController < ApplicationController
      before_action :users_count

      # GET /api/v1/report/infected_users
      # Returns the percentage of infected users
      def infected_users
        infected_users_count = Infection.infected_users_count

        if @users > 0
          percentage = (infected_users_count.to_f / @users) * 100

          render json: { Percentage: percentage }, status: :ok
        else
          render json: { error: 'No users found' }, status: :not_found
        end
      end

      # GET /api/v1/report/non_infected_users
      # Returns the percentage of non infected users
      def non_infected_users
        non_infected_users_count = Infection.non_infected_users_count

        if @users > 0
          percentage = (non_infected_users_count.to_f / @users) * 100

          render json: { Percentage: percentage }, status: :ok
        else
          render json: { error: 'No users found' }, status: :not_found
        end
      end

      # GET /api/v1/report/item_average_per_user
      # Returns the average of items per user
      def item_average_per_user
        items_average = Inventory.average_items_quantity_per_user

        if @users > 0
          render json: { 'Items average': items_average }, status: :ok
        else
          render json: { error: 'No users found' }, status: :not_found
        end
      end

      # GET /api/v1/report/number_of_lost_points_by_infected_users
      # Returns the total of lost points by infected users
      def number_of_lost_points_by_infected_users
        if @users > 0
          lost_points = Infection.lost_points

          render json: { 'Total lost points': lost_points }, status: :ok
        else
          render json: { error: 'No users found' }, status: :not_found
        end
      end

      private

      def users_count
        @users = User.count
      end
    end
  end
end
