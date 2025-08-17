class CreatePromo < ActiveRecord::Migration[7.2]
  def up
    create_table :promos do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.text :description
      t.string :status, null: false, default: "active"
      t.timestamps
    end
  end

  def down
    drop_table :promos, if_exists: true
  end
end
