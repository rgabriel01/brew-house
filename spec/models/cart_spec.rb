# == Schema Information
#
# Table name: carts
#
#  id                 :integer          not null, primary key
#  discounts          :decimal(10, 2)   not null
#  gross_price        :decimal(10, 2)   not null
#  net_price          :decimal(10, 2)   not null
#  transaction_date   :date
#  transaction_number :integer          not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
require 'rails_helper'

RSpec.describe Cart, type: :model do
  let(:product1) { create(:product, name: "Canned Tuna", description: "Packed with Omega 3", price: 3) }
  let(:product2) { create(:product, name: "Coffee", description: "A rich and aromatic coffee blend.", price: 3) }

  context "validations" do
    it "validates for presence of transaction_date" do
      cart = Cart.new(transaction_date: nil, gross_price: 100.00, net_price: 90.00, discounts: 10.00)
      expect(cart.valid?).to be_falsey
    end

    it "validates for presence of gross_price" do
      cart = Cart.new(transaction_date: Date.today, gross_price: nil, net_price: 90.00, discounts: 10.00)
      expect(cart.valid?).to be_falsey
    end

    it "validates for presence of net_price" do
      cart = Cart.new(transaction_date: Date.today, gross_price: 100.00, net_price: nil, discounts: 10.00)
      expect(cart.valid?).to be_falsey
    end

    it "validates for presence of discounts" do
      cart = Cart.new(transaction_date: Date.today, gross_price: 100.00, net_price: 90.00, discounts: nil)
      expect(cart.valid?).to be_falsey
    end
  end

  context "relationships" do
    it "has many cart_items" do
      cart = Cart.new({
        transaction_date: Date.today,
        gross_price: 6.00,
        net_price: 6.00,
        discounts: 0,
        cart_items_attributes: [
          { product_id: product1.id, quantity: 1, gross_price: product1.price, net_price: product1.price, subtotal: product1.price, discounts: 0 },
          { product_id: product2.id, quantity: 1, gross_price: product2.price, net_price: product2.price, subtotal: product2.price, discounts: 0 }
        ]
      })

      expect(cart.valid?).to be_truthy
      expect(cart.cart_items.size).to eq(2)
      expect(cart.save).to be_truthy
      expect(cart.transaction_number).to eq(1)
    end
  end
end
