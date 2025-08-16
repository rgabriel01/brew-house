class CreateProducts < ActiveRecord::Migration[7.2]
  def up
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :price, precision: 10, scale: 2, null: false
      t.timestamps
    end
  end

  def down
    drop_table :products, if_exists: true
  end
end
