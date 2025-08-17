require "rails_helper"

RSpec.describe PromoDetail, type: :model do
  context "relationships" do
    let(:product) { create(:product, name: "Surf board", price: 1) }

    let(:promo) { create(:promo, name: "Summer Sale", code: "SUMMER2025", promo_type:) }
    let(:promo_type) { Promo.promo_types[:buy_one_get_one] }

    it "belongs to a promo" do
      promo_detail = create(:promo_detail, promo:, product:)
      expect(promo_detail.promo).to eq(promo)
      expect(promo_detail.product).to eq(product)
    end

    it "belongs to a product" do
      promo_detail = create(:promo_detail, promo:, product:)
      expect(promo_detail.promo).to eq(promo)
      expect(promo_detail.product).to eq(product)
    end
  end
end
