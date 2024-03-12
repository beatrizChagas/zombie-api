# frozen_string_literal: true

module Api
  module V1
    class InventoriesController < ApplicationController
      include InventoryHelper

      before_action :check_user_access, only: %i[add_item remove_item]

      # POST /users/:user_id/inventory/add_item
      def add_item
        @inventory = Inventory.find_by(user_id: params[:user_id])

        if @inventory && item_permited_key?
          if item_exists?
            increment_quantity(params[:items][key][:quantity])
          else
            @inventory.items.update(inventory_params['items'])
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

      def transfer_items
        user = User.find(params[:user_id])
        target_user = User.find(params[:target_user_id])

        user_items = params[:items]
        target_user_items = params[:target_user_items]

        if user_items_quantity_exist?(user.inventory,
                                      user_items) && user_items_quantity_exist?(target_user.inventory,
                                                                                target_user_items)
          # Validate that both users negotiate the same number of points
          unless same_points?(user_items, target_user_items)
            render json: { error: 'Both users must negotiate the same number of points' }, status: :unprocessable_entity
          end

          # Transfer inventory items from user to target_user
          user.inventory.transfer(user_items, target_user)
          target_user.inventory.transfer(target_user_items, user)

          render json: { message: 'Inventory items transferred successfully' }, status: :ok
        else
          render json: { error: 'User does not have enough items to transfer' }, status: :unprocessable_entity
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

      def check_user_access
        user = User.find(params[:user_id])
        return unless user.infected?

        render json: { error: 'You are not authorized to access add/remove items' }, status: :forbidden
      end

      def user_items_quantity_exist?(inventory, items)
        items.each do |key, value|
          return false unless inventory.items[key]
          return false if inventory.items[key]['quantity'] < value['quantity']

          return true
        end
      end

      def same_points?(user_items, target_user_items)
        user_points = 0
        target_user_points = 0

        user_items.keys.each do |key|
          user_points += Inventory.calculate_point(key, user_items[key]['quantity'])
        end

        target_user_items.keys.each do |key|
          target_user_points += Inventory.calculate_point(key, target_user_items[key]['quantity'])
        end

        return false if user_points != target_user_points

        true
      end
    end
  end
end
