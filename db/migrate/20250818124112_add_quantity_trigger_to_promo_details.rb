class AddQuantityTriggerToPromoDetails < ActiveRecord::Migration[7.2]
  def up
    add_column :promo_details, :quantity_trigger, :integer, if_not_exists: true
  end

  def down
    remove_column :promo_details, :quantity_trigger
  end
end
