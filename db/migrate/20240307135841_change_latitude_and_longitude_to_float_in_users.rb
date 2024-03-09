class ChangeLatitudeAndLongitudeToFloatInUsers < ActiveRecord::Migration[7.1]
  def up
    change_column :users, :latitude, :float, using: 'latitude::double precision'
    change_column :users, :longitude, :float, using: 'longitude::double precision'
  end

  def down
    change_column :users, :latitude, :string
    change_column :users, :longitude, :string
  end
end
