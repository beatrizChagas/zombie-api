# frozen_string_literal: true

class Infection < ApplicationRecord
  belongs_to :infected_user, class_name: 'User'
  belongs_to :user, class_name: 'User'

  def self.infected_users_count
    User.where(id: infected_user_ids).count
  end

  def self.non_infected_users_count
    User.where.not(id: infected_user_ids).count
  end

  def self.lost_points
    users = User.where(id: infected_user_ids)

    users.map { |user| user.inventory.total_points }.sum
  end

  private

  def self.infected_user_ids
    group(:infected_user_id).having("COUNT(DISTINCT user_id) >= 3").pluck(:infected_user_id)
  end
end
