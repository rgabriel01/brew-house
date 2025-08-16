# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  description :text
#  name        :string           not null
#  price       :decimal(10, 2)   not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Product, type: :model do
  context "validations" do
    it "validates for presence of name" do
      product = Product.new(name: nil, price: 19.99)
      expect(product.valid?).to be_falsey
    end

    it "validates for presence of price" do
      product = Product.new(name: "Orange", price: nil)
      expect(product.valid?).to be_falsey
    end
  end
end
