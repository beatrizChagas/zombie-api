# frozen_string_literal: true

class User < ApplicationRecord
  after_create :create_inventory

  has_one :inventory, dependent: :destroy

  enum gender: { female: 0, male: 1 }

  validates :name, presence: true, length: { minimum: 3 }
  validates :age, :gender, :latitude, :longitude, presence: true

  private

  def create_inventory
    Inventory.create(user: self)
  end
end
