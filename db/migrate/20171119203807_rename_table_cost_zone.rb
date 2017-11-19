class RenameTableCostZone < ActiveRecord::Migration[5.1]
  def change
    rename_table :cost_zones, :costzones
  end
end
