class AddProductIdToPromoDetails < ActiveRecord::Migration[7.2]
  def up
    add_reference :promo_details, :product, null: false, foreign_key: true
  end

  def down
    remove_reference :promo_details, :product, if_exists: true
  end
end
