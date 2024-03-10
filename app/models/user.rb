# frozen_string_literal: true

class User < ApplicationRecord
  after_create :create_inventory

  has_one :inventory, dependent: :destroy
  has_many :infection, dependent: :destroy

  enum gender: { female: 0, male: 1 }

  validates :name, presence: true, length: { minimum: 3 }
  validates :age, :gender, :latitude, :longitude, presence: true

  def infected?
    Infection.where(infected_user: self).distinct.count >= 3
  end

  private

  def create_inventory
    Inventory.create(user: self)
  end
end
