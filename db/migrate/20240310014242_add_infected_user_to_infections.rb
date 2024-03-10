class AddInfectedUserToInfections < ActiveRecord::Migration[7.1]
  def change
    add_reference :infections, :infected_user, null: true

    add_foreign_key :infections, :users, column: :infected_user_id
  end
end
