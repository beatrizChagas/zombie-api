# frozen_string_literal: true

module Api
  module V1
    class InventoriesController < ApplicationController
      include InventoryHelper
      include JsonResponse

      before_action :find_user_and_inventory, only: %i[add_item remove_item transfer_items]
      before_action :find_target_user_and_inventory, only: [:transfer_items]
      before_action :check_user_access, only: %i[add_item remove_item transfer_items]
      before_action :check_target_user_access, only: [:transfer_items]

      # POST /api/v1/users/:user_id/inventory/add_item
      # Add items to inventory
      def add_item
        items = inventory_params['items']

        if !items.empty?
          update_inventory(items)

          render_blueprint(InventoryBlueprint, @inventory, :created)
        else
          render_error('Items cannot be empty', :unprocessable_entity)
        end
      end

      # POST /api/v1/users/:user_id/inventory/remove_item
      # Remove items from inventory
      def remove_item
        items = inventory_params['items']

        if !items.empty?
          update_decrement_quantity(items)

          render_blueprint(InventoryBlueprint, @inventory, :ok)
        else
          render_error('Items cannot be empty', :unprocessable_entity)
        end
      end

      # POST /api/v1/users/:user_id/transfers/:target_user_id
      # Transfer items from one user to another
      def transfer_items
        user_items = inventory_params['items']
        target_user_items = inventory_params['target_user_items']

        if !user_items.empty? || !target_user_items.empty?
          # Validate if user has enough items to transfer and if the points are the same
          if enough_items_to_transfer?(user_items, target_user_items) && negotiate_same_number_of_points?(user_items, target_user_items)
            transfer_inventory_items(user_items, target_user_items)

            render_success('Inventory items transferred successfully', :ok)
          else
            render_error('User does not have enough items to transfer', :unprocessable_entity)
          end
        else
          render_error('Items cannot be empty', :unprocessable_entity)
        end
      end

      private

      def inventory_params
        params.permit(items: { water: [:quantity],
                               food: [:quantity],
                               medicine: [:quantity],
                               ammunition: [:quantity] },
                      target_user_items: { water: [:quantity],
                               food: [:quantity],
                               medicine: [:quantity],
                               ammunition: [:quantity] })
      end

      def find_user_and_inventory
        @user = User.find_by(id: params[:user_id])
        @inventory = Inventory.find_by(user_id: params[:user_id])
      end

      def find_target_user_and_inventory
        @target_user = User.find_by(id: params[:target_user_id])
        @target_inventory = Inventory.find_by(user_id: params[:target_user_id])
      end

      def check_user_access
        if @user
          if @user.infected?
            render_error('You are not authorized to add/remove items', :forbidden)
          end
        else
          render_error('User not found', :not_found)
        end
      end

      def check_target_user_access
        if @target_user
          if @target_user.infected?
            render_error('You are not authorized to transfer items', :forbidden)
          end
        else
          render_error('Target user not found', :not_found)
        end
      end

      def update_inventory(items)
        items.each do |key, value|
          @inventory.items[key] ||= { 'quantity' => 0 }
          @inventory.items[key]['quantity'] += value['quantity'].to_i
        end

        @inventory.save
      end

      def increment_quantity(key, value)
        @inventory.items[key]['quantity'] += value['quantity'].to_i
      end

      def update_decrement_quantity(items)
        items.each do |key, value|
          @inventory.items[key]['quantity'] -= value['quantity']
        end

        @inventory.save
      end

      def enough_items_to_transfer?(user_items, target_user_items)
        @inventory.has_enough_items?(user_items) && @target_inventory.has_enough_items?(target_user_items)
      end

      def negotiate_same_number_of_points?(user_items, target_user_items)
        @inventory.negotiate_points(user_items) == @target_inventory.negotiate_points(target_user_items)
      end

      def transfer_inventory_items(user_items, target_user_items)
        @user.inventory.transfer(user_items, @target_user)
        @target_user.inventory.transfer(target_user_items, @user)
      end
    end
  end
end
