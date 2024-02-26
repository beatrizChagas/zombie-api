class CreateInfections < ActiveRecord::Migration[7.1]
  def change
    create_table :infections do |t|
      t.references :user, null: false
      t.references :reported_by, null: false

      t.timestamps
    end

    add_foreign_key :infections, :users, column: :user_id
    add_foreign_key :infections, :users, column: :reported_by_id
  end
end
