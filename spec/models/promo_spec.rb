# == Schema Information
#
# Table name: promos
#
#  id          :integer          not null, primary key
#  code        :string           not null
#  description :text
#  name        :string           not null
#  promo_type  :string           not null
#  status      :string           default("active"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'rails_helper'

RSpec.describe Promo, type: :model do
  shared_examples "with required fields" do |field_name|
    it "validates presence of #{field_name}" do
      promo = Promo.new(field_name => nil)
      expect(promo.valid?).to be_falsey
      expect(promo.errors[field_name]).to include("can't be blank")
    end
  end

  it_behaves_like "with required fields", :name
  it_behaves_like "with required fields", :code
  it_behaves_like "with required fields", :promo_type

  context "uniqueness validation" do
    it "validates uniqueness of code" do
      Promo.create!(name: "Summer Sale", code: "SUMMER2023", promo_type: Promo.promo_types[:buy_one_get_one])
      promo = Promo.new(name: "Winter Sale", code: "SUMMER2023", promo_type: Promo.promo_types[:buy_one_get_one])

      expect(promo.valid?).to be_falsey
      expect(promo.errors[:code]).to include("has already been taken")
    end
  end

  context "relationships" do
    let(:product) { create(:product, name: "Surf board", price: 1) }

    let(:promo) { create(:promo, name: "Summer Sale", code: "SUMMER2025", promo_type:) }
    let(:promo_type) { Promo.promo_types[:buy_one_get_one] }

    let!(:promo_detail) { create(:promo_detail, promo:, product:) }

    it "has many promo_details" do
      expect(promo.promo_details).to include(promo_detail)
    end
  end
end
