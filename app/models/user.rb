class User < ApplicationRecord
  has_one :inventory

  enum gender: { 'female': 0, 'male': 1 }

  validates :name, presence: true, length: { minimum: 3 }
  validates :age, :gender, :latitude, :longitude, presence: true
end
