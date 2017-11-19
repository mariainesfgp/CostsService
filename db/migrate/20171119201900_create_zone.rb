class CreateZone < ActiveRecord::Migration[5.1]
  def change
    create_table :zones do |t|
      t.integer :identify
      t.string :name
      t.string :polygon
    end
  end
end
