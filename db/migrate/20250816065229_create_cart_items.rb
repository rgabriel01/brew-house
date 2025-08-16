class CreateCartItems < ActiveRecord::Migration[7.2]
  def up
    create_table :cart_items do |t|
      t.references :cart, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, null: false, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.decimal :gross_price, precision: 10, scale: 2, null: false
      t.decimal :net_price, precision: 10, scale: 2, null: false
      t.decimal :discounts, precision: 10, scale: 2, null: false
      t.text :notes
      t.timestamps
    end
  end

  def down
    drop_table :cart_items, if_exists: true
  end
end
