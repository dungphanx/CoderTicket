class CreateOrderDetails < ActiveRecord::Migration
  def change
    create_table :order_details do |t|
      t.integer :quantity
      t.decimal :price
      t.decimal :total_price
      t.references :order, index: true, foreign_key: true
      t.references :ticket_type, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
