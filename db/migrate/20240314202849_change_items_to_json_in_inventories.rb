class ChangeItemsToJsonInInventories < ActiveRecord::Migration[7.1]
  def up
    change_column :inventories, :items, :json, using: 'items::json', default: {}
  end

  def down
    change_column :inventories, :items, :string
  end
end
