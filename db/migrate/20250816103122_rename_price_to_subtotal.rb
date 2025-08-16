class RenamePriceToSubtotal < ActiveRecord::Migration[7.2]
  def up
    rename_column :cart_items, :price, :subtotal
  end

  def down
    rename_column :cart_items, :subtotal, :price
  end
end
