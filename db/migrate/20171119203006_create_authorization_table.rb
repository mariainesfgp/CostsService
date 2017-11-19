class CreateAuthorizationTable < ActiveRecord::Migration[5.1]
  def change
    create_table :authorization do |t|
      t.timestamps
      t.string :user_id
      t.string :token
    end
  end
end
