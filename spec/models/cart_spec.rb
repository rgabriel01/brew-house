# == Schema Information
#
# Table name: carts
#
#  id               :integer          not null, primary key
#  discounts        :decimal(10, 2)   not null
#  gross_price      :decimal(10, 2)   not null
#  net_price        :decimal(10, 2)   not null
#  transaction_date :date
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
require 'rails_helper'

RSpec.describe Cart, type: :model do
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
end
