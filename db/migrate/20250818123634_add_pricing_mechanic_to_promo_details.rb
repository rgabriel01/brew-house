class AddPricingMechanicToPromoDetails < ActiveRecord::Migration[7.2]
  def up
    add_column :promo_details, :pricing_mechanic, :string, if_not_exists: true
  end

  def down
    remove_column :promo_details, :pricing_mechanic
  end
end
