# frozen_string_literal: true

class Infection < ApplicationRecord
  belongs_to :infected_user, class_name: 'User'
  belongs_to :user, class_name: 'User'

  def self.infected_users_count
    infected_users = group(:infected_user_id).distinct.count(:user_id)

    infected_user_ids = infected_users.select { |infected_user_id, count| count >= 3 }.keys

    User.where(id: infected_user_ids).count
  end
end
