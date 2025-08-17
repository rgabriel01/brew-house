# == Schema Information
#
# Table name: promo_details
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  product_id :integer          not null
#  promo_id   :integer          not null
#
# Indexes
#
#  index_promo_details_on_product_id  (product_id)
#  index_promo_details_on_promo_id    (promo_id)
#
# Foreign Keys
#
#  product_id  (product_id => products.id)
#  promo_id    (promo_id => promos.id)
#
class PromoDetail < ApplicationRecord
  belongs_to :promo
  belongs_to :product

  validates :promo, :product, presence: true
end
