# frozen_string_literal: true

class Inventory < ApplicationRecord
  include InventoryHelper

  belongs_to :user

  serialize :items, coder: JSON, type: Hash, default: {}

  def self.calculate_point(item_key, item_quantity)
    @point = case item_key
             when 'water'
               item_quantity * 4
             when 'food'
               item_quantity * 3
             when 'medicine'
               item_quantity * 2
             when 'ammunition'
               item_quantity * 1
             end

    @point
  end

  def self.average_items_quantity_per_user
    average = {}
    items = Inventory.all.map(&:items)
    users_count = User.count

    total_quantity = total_quantity_per_user(items)

    total_quantity.each_key do |key|
      average[key] = total_quantity[key].to_f / users_count
    end

    average
  end

  def transfer(target_user_items, target_user)
    inventory_items = self.items
    target_inventory = target_user.inventory

    target_user_items.each do |key, value|
      if target_inventory.items[key]
        target_inventory.items[key]['quantity'] += value['quantity']
      else
        target_inventory.items[key] = {}
        target_inventory.items[key]['quantity'] = value['quantity']
      end

      points = Inventory.calculate_point(key, target_inventory.items[key]['quantity'].to_i)
      target_inventory.items[key]['points'] = points
    end

    inventory_items.each do |key, value|
      return unless target_user_items[key]

      inventory_items[key]['quantity'] -= target_user_items[key]['quantity']
      points = Inventory.calculate_point(key, inventory_items[key]['quantity'].to_i)
      inventory_items[key]['points'] = points
    end

    target_inventory.save
    self.save
  end

  def total_points
    total_points = 0

    items.each do |key, value|
      total_points += Inventory.calculate_point(key, value['quantity'])
    end

    total_points
  end

  private

  def self.total_quantity_per_user(items)
    total_quantity = {}

    PERMITTED_ITEMS.each do |key|
      total_quantity[key] = items.map do |item|
        item[key]['quantity'] if item[key]
      end

      total_quantity[key] = total_quantity[key].compact.sum
    end

    total_quantity
  end
end
