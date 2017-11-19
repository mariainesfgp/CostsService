class CreateTable < ActiveRecord::Migration[5.1]
  def change
    create_table :costzones do |t|
      t.integer :zoneFrom
      t.integer :zoneTo
      t.decimal :cost1
      t.decimal :cost2
      t.decimal :cost3
      t.integer :lastUpdate
      t.timestamps
    end
  end
end
