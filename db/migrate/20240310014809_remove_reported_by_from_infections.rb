class RemoveReportedByFromInfections < ActiveRecord::Migration[7.1]
  def change
    remove_column :infections, :reported_by_id
  end
end
