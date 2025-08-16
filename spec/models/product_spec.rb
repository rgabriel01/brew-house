# rspec spec/models/product_spec.rb
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
