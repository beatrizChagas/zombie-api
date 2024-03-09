# frozen_string_literal: true

class Inventory < ApplicationRecord
  include InventoryConstants

  belongs_to :user

  serialize :items,
            coder: JSON,
            type: Hash,
            default: ITEMS
end
