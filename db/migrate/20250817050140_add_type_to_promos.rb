class AddTypeToPromos < ActiveRecord::Migration[7.2]
  def up
    add_column :promos, :type, :string, null: false
  end

  def down
    remove_column :promos, :type, if_exists: true
  end
end
