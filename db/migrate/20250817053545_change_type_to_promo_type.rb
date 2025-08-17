class ChangeTypeToPromoType < ActiveRecord::Migration[7.2]
  def up
    rename_column :promos, :type, :promo_type
  end

  def down
    rename_column :promos, :promo_type, :type
  end
end
