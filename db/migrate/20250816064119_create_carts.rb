class CreateCarts < ActiveRecord::Migration[7.2]
  def up
    create_table :carts do |t|
      t.date :transaction_date
      t.decimal :gross_price, precision: 10, scale: 2, null: false
      t.decimal :net_price, precision: 10, scale: 2, null: false
      t.decimal :discounts, precision: 10, scale: 2, null: false
      t.timestamps
    end
  end

  def down
    drop_table :carts, if_exists: true
  end
end
