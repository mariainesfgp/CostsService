class RenameTable < ActiveRecord::Migration[5.1]
  def change
    rename_table :authorization_tables, :authorization
  end
end
