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
  shared_examples "with required fields" do |field_name|
    it "validates presence of #{field_name}" do
      product = Product.new(field_name => nil)
      expect(product.valid?).to be_falsey
      expect(product.errors[field_name]).to include("can't be blank")
    end
  end

  it_behaves_like "with required fields", :name
  it_behaves_like "with required fields", :price

  context "relationships" do
    let(:product) { create(:product, name: "Surf board", price: 1) }
    let(:promo) { create(:promo, name: "Summer Sale", code: "SUMMER2025", promo_type: Promo.promo_types[:buy_one_get_one]) }
    let!(:promo_detail) { create(:promo_detail, promo:, product:) }

    it "has many promos through promo_details" do
      expect(product.promos).to include(promo)
    end
  end
end
