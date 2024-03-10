# frozen_string_literal: true

class Infection < ApplicationRecord
  belongs_to :infected_user, class_name: 'User'
  belongs_to :user, class_name: 'User'
end
