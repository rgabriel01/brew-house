# == Schema Information
#
# Table name: cart_items
#
#  id          :integer          not null, primary key
#  discounts   :decimal(10, 2)   not null
#  gross_price :decimal(10, 2)   not null
#  net_price   :decimal(10, 2)   not null
#  notes       :text
#  price       :decimal(10, 2)   not null
#  quantity    :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  cart_id     :integer          not null
#  product_id  :integer          not null
#
# Indexes
#
#  index_cart_items_on_cart_id     (cart_id)
#  index_cart_items_on_product_id  (product_id)
#
# Foreign Keys
#
#  cart_id     (cart_id => carts.id)
#  product_id  (product_id => products.id)
#
require 'rails_helper'

RSpec.describe CartItem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
