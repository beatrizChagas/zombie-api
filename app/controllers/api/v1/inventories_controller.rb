# frozen_string_literal: true

module Api
  module V1
    class InventoriesController < ApplicationController
      include InventoryHelper

      before_action :allow_user, only: %i[add_item remove_item]

      # POST /users/:user_id/inventory/add_item
      def add_item
        @inventory = Inventory.find_by(user_id: params[:user_id])

        if @inventory && item_permited_key?
          if item_exists?
            increment_quantity(params[:items][key][:quantity])
          else
            @inventory.update(inventory_params)
          end

          update_item_quantity
          update_item_points

          if @inventory.save
            render json: InventoryBlueprint.render(@inventory), status: :created
          else
            render @inventory.errors, status: :unprocessable_entity
          end
        else
          render json: { error: 'Inventory not found or item not permitted' },
                 status: :unprocessable_entity
        end
      end

      # POST /users/:user_id/inventory/remove_item
      def remove_item
        @inventory = Inventory.find_by(user_id: params[:user_id])

        if @inventory && item_exists?
          decrement_quantity(params[:items][key][:quantity])

          update_item_points

          if @inventory.save
            render json: InventoryBlueprint.render(@inventory), status: :ok
          else
            render @inventory.errors, status: :unprocessable_entity
          end
        else
          render json: { error: 'Inventory not found or item does not exist' },
                 status: :unprocessable_entity
        end
      end

      private

      def inventory_params
        params.permit(items: { water: [:quantity],
                               food: [:quantity],
                               medicine: [:quantity],
                               ammunition: [:quantity] })
      end

      def update_item_quantity
        @inventory.items[key]['quantity'] = @inventory.items[key]['quantity'].to_i
      end

      def update_item_points
        points = Inventory.calculate_point(key, @inventory['items'][key]['quantity'].to_i)

        @inventory.items[key]['points'] = points
      end

      def key
        params[:items].keys.first
      end

      def item_permited_key?
        PERMITTED_ITEMS.include?(params[:items].keys.first)
      end

      def item_exists?
        @inventory.items.include?(params[:items].keys.first)
      end

      def increment_quantity(value)
        @inventory.items[key]['quantity'] += value
      end

      def decrement_quantity(value)
        @inventory.items[key]['quantity'] -= value
      end

      def allow_user
        user = User.find(params[:user_id])
        if user.infected?
          render json: { error: 'You are not authorized to access add/remove items' }, status: :forbidden
        end
      end
    end
  end
end
