class CreatePromoDetails < ActiveRecord::Migration[7.2]
  def up
    create_table :promo_details do |t|
      t.references :promo, null: false, foreign_key: true
      t.timestamps
    end
  end

  def down
    drop_table :promo_details, if_exists: true
  end
end
