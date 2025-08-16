class AddTransactionNumberToCarts < ActiveRecord::Migration[7.2]
  def up
    add_column :carts, :transaction_number, :integer, null: false, if_not_exists: true
  end

  def down
    remove_column :carts, :transaction_number, if_exists: true
  end
end
