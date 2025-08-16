# == Schema Information
#
# Table name: cart_items
#
#  id          :integer          not null, primary key
#  discounts   :decimal(10, 2)   not null
#  gross_price :decimal(10, 2)   not null
#  net_price   :decimal(10, 2)   not null
#  notes       :text
#  quantity    :integer          not null
#  subtotal    :decimal(10, 2)   not null
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
  let(:product) { create(:product, name: "Canned Tuna", description: "Packed with Omega 3", price: 3) }

  context "validations" do
    it "validates for presence of cart" do
      cart_item = CartItem.new(product_id: product.id, quantity: nil, gross_price: 10.00, net_price: 9.00, discounts: 1.00, subtotal: 9.00)
      expect(cart_item.valid?).to be_falsey
      expect(cart_item.errors.full_messages).to include("Cart must exist")
    end

    it "validates for presence of product" do
      cart_item = CartItem.new(cart_id: 1, product_id: nil, quantity: 1, gross_price: 10.00, net_price: 9.00, discounts: 1.00, subtotal: 9.00)
      expect(cart_item.valid?).to be_falsey
      expect(cart_item.errors.full_messages).to include("Product must exist")
    end

    it "validates for presence of quantity" do
      cart_item = CartItem.new(cart_id: 1, product_id: product.id, quantity: nil, gross_price: 10.00, net_price: 9.00, discounts: 1.00, subtotal: 9.00)
      expect(cart_item.valid?).to be_falsey
      expect(cart_item.errors.full_messages).to include("Quantity can't be blank")
    end

    it "validates for presence of gross_price" do
      cart_item = CartItem.new(cart_id: 1, product_id: product.id, quantity: 1, gross_price: nil, net_price: 9.00, discounts: 1.00, subtotal: 9.00)
      expect(cart_item.valid?).to be_falsey
      expect(cart_item.errors.full_messages).to include("Gross price can't be blank")
    end

    it "validates for presence of net_price" do
      cart_item = CartItem.new(cart_id: 1, product_id: product.id, quantity: 1, gross_price: 10.00, net_price: nil, discounts: 1.00, subtotal: 9.00)
      expect(cart_item.valid?).to be_falsey
      expect(cart_item.errors.full_messages).to include("Net price can't be blank")
    end

    it "validates for presence of discounts" do
      cart_item = CartItem.new(cart_id: 1, product_id: product.id, quantity: 1, gross_price: 10.00, net_price: 9.00, discounts: nil, subtotal: 9.00)
      expect(cart_item.valid?).to be_falsey
      expect(cart_item.errors.full_messages).to include("Discounts can't be blank")
    end
  end
end
