class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :name
      t.string :address
      t.string :email
      t.string :phone
      t.references :event, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
