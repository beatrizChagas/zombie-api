class CreateInventories < ActiveRecord::Migration[7.1]
  def change
    create_table :inventories do |t|
      t.string :items
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
