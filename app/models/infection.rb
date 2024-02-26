class Infection < ApplicationRecord
  belongs_to :reported_by, class_name: 'User'
  belongs_to :user, class_name: 'User'
end
