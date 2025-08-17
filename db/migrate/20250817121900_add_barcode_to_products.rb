class AddBarcodeToProducts < ActiveRecord::Migration[7.2]
  def up
    add_column :products, :barcode, :string, null: false
  end

  def down
    remove_column :products, :barcode
  end
end
