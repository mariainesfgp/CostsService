class CreateCosts < ActiveRecord::Migration[5.1]
  def change
    create_table :costs do |t|
      t.timestamps
      t.decimal :cost1
      t.decimal :cost2
      t.decimal :cost3
      t.integer :lastUpdate
    end
  end
end
