# frozen_string_literal: true

class Inventory < ApplicationRecord
  include InventoryConstants

  belongs_to :user

  serialize :items, coder: JSON, type: Hash, default: {}

  def self.calculate_point(item_key, item_quantity)
    case item_key
    when 'water'
      @point = item_quantity * 4
    when 'food'
      @point = item_quantity * 3
    when 'medicine'
      @point = item_quantity * 2
    when 'ammunition'
      @point = item_quantity * 1
    else
      @point = nil
    end

    @point
  end
end
