require 'rails_helper'

RSpec.describe Carts::CreateService, type: :service do
  describe ".call" do
    subject do
      described_class.call(
        params:
      )
    end

    let(:params) do
      {
        cart_items: [
          { product_id: product1.id, quantity: 2, gross_price: product1.price, net_price: product1.price, subtotal: (product1.price * 2), discounts: 0 },
          { product_id: product2.id, quantity: 1, gross_price: product2.price, net_price: product2.price, subtotal: product2.price, discounts: 0 }
        ]
      }
    end

    let(:product1) { create(:product, name: "Canned Tuna", description: "Packed with Omega 3", price: 3) }
    let(:product2) { create(:product, name: "Coffee", description: "A rich and aromatic coffee blend.", price: 3) }

    # Freeze time for consistent test results
    before do
      timestamp = Time.local(2025, 5, 10, 10, 30, 0) # May 10, 2025, 10:30 AM
      Timecop.freeze(timestamp)
    end

    after do
      Timecop.return
    end

    context "when valid parameters are provided" do
      it "creates a cart then computes for the necessary totals" do
        result = subject

        expect(result[:success]).to be_truthy

        cart = result[:cart]
        expect(cart[:transaction_date]).to eq(Date.new(2025, 5, 10))
        expect(cart[:transaction_number]).to eq(1) # Assuming this is the first cart created
        expect(cart[:gross_price]).to eq(9.00)
        expect(cart[:net_price]).to eq(9.00)
        expect(cart[:discounts]).to eq(0)

        cart_items = cart.cart_items
        expect(cart_items.size).to eq(2)

        cart_items.each do |cart_item|
          product = [ product1, product2 ].find { |product| product.id == cart_item.product_id }
          expect(cart_item[:gross_price]).to eq(product.price)
          expect(cart_item[:net_price]).to eq(product.price)
          expect(cart_item[:subtotal]).to eq(product.price * cart_item[:quantity])
          expect(cart_item[:discounts]).to eq(0)
        end
      end
    end

    context "cart_items consolidation" do
      let(:params) do
        {
          cart_items: [
            { product_id: product1.id, quantity: 2, gross_price: product1.price, net_price: product1.price, subtotal: (product1.price * 2), discounts: 0 },
            { product_id: product2.id, quantity: 1, gross_price: product2.price, net_price: product2.price, subtotal: product2.price, discounts: 0 },
            { product_id: product1.id, quantity: 1, gross_price: product1.price, net_price: product1.price, subtotal: product1.price, discounts: 0 }
          ]
        }
      end

      it "correctly consolidates product on the cart_items and resolves computations" do
        result = subject
        expect(result[:success]).to be_truthy

        cart = result[:cart]
        expect(cart[:transaction_date]).to eq(Date.new(2025, 5, 10))
        expect(cart[:transaction_number]).to eq(1) # Assuming this is the first cart created
        expect(cart[:gross_price]).to eq(12.00)
        expect(cart[:net_price]).to eq(12.00)
        expect(cart[:discounts]).to eq(0)
        expect(cart.cart_items.size).to eq(2) # 3 line items, with 2 unique products into just 2 lines

        cart_items = cart.cart_items

        cart_items.each do |cart_item|
          product = [ product1, product2 ].find { |product| product.id == cart_item.product_id }
          expect(cart_item[:gross_price]).to eq(product.price)
          expect(cart_item[:net_price]).to eq(product.price)
          expect(cart_item[:subtotal]).to eq(product.price * cart_item[:quantity])
          expect(cart_item[:discounts]).to eq(0)
        end
      end
    end

    context "when cart_items are eligible for promotions" do
      context "with a buy one get one promotion" do
        let!(:product) { create(:product, name: "Summer Kiss Lotion", description: "Yet another one of those summer products", price: 3) }
        let!(:product2) { create(:product, name: "Banana Towel", description: "Yet another one of those super absorbent towels", price: 1) }
        let!(:promo) { create(:promo, name: "Summer Sale", code: "SUMMERSALE", description: "Yet another summer sale!", promo_type: Promo.promo_types[:buy_one_get_one]) }
        let!(:promo_detail) { create(:promo_detail, promo:, product:) }
        let(:params) do
          {
            cart_items: [
              { product_id: product.id, quantity: 1, gross_price: product.price, net_price: product.price, subtotal: product.price * 1, discounts: 0 },
              { product_id: product.id, quantity: 1, gross_price: product.price, net_price: product.price, subtotal: product.price * 1, discounts: 0 },
              { product_id: product.id, quantity: 1, gross_price: product.price, net_price: product.price, subtotal: product.price * 1, discounts: 0 },
              { product_id: product2.id, quantity: 1, gross_price: product2.price, net_price: product2.price, subtotal: product2.price * 1, discounts: 0 }
            ]
          }
        end

        it "applies the promotion mechanics accordingly" do
          result = subject

          cart = result[:cart]
          expect(result[:success]).to be_truthy
          expect(cart[:transaction_date]).to eq(Date.new(2025, 5, 10))
          expect(cart[:transaction_number]).to eq(1) # Assuming this is the first cart created
          expect(cart[:gross_price]).to eq(7.00)
          expect(cart[:net_price]).to eq(7.00)
          expect(cart[:discounts]).to eq(0)
          expect(cart.cart_items.size).to eq(3) # 3 line items, with 2 unique products into just 2 lines

          cart_items = cart.cart_items

          expect(cart_items.select { |cart_item| cart_item.gross_price == 0 }.length).to eq(1) # One item should be free due to the promotion
          expect(cart_items.select { |cart_item| cart_item.gross_price > 0 }.length).to eq(2) # One item should be full price due to the promotion
        end

        context "when product items are consolidated" do
          let(:params) do
            {
              cart_items: [
                { product_id: product.id, quantity: 3, gross_price: product.price, net_price: product.price, subtotal: product.price * 3, discounts: 0 },
                { product_id: product2.id, quantity: 1, gross_price: product2.price, net_price: product2.price, subtotal: product2.price * 1, discounts: 0 }
              ]
            }
          end

          it "applies the promotion mechanics accordingly" do
            result = subject

            cart = result[:cart]
            expect(result[:success]).to be_truthy
            expect(cart[:transaction_date]).to eq(Date.new(2025, 5, 10))
            expect(cart[:transaction_number]).to eq(1) # Assuming this is the first cart created
            expect(cart[:gross_price]).to eq(7.00)
            expect(cart[:net_price]).to eq(7.00)
            expect(cart[:discounts]).to eq(0)
            expect(cart.cart_items.size).to eq(3) # 3 line items, with 2 unique products into just 2 lines

            cart_items = cart.cart_items

            expect(cart_items.select { |cart_item| cart_item.gross_price == 0 }.length).to eq(1) # One item should be free due to the promotion
            expect(cart_items.select { |cart_item| cart_item.gross_price > 0 }.length).to eq(2) # One item should be full price due to the promotion
          end
        end
      end

      context "with a buy more pay less promotion" do
        let!(:product) { create(:product, name: "Strawberries", description: "Sweet and juicy!", price: 5) }
        let!(:promo) { create(:promo, name: "Buy more, Pay less", code: "BMPL", description: "Yet another buy more fruit for less", promo_type: Promo.promo_types[:buy_more_pay_less]) }
        let!(:promo_detail) { create(:promo_detail, promo:, product:, pricing_mechanic:, quantity_trigger:) }
        let(:pricing_mechanic) { "4.5" }
        let(:quantity_trigger) { 3 }
        let(:params) do
          {
            cart_items: [
              { product_id: product.id, quantity: 1, gross_price: product.price, net_price: product.price, subtotal: product.price * 1, discounts: 0 },
              { product_id: product.id, quantity: 1, gross_price: product.price, net_price: product.price, subtotal: product.price * 1, discounts: 0 },
              { product_id: product.id, quantity: 1, gross_price: product.price, net_price: product.price, subtotal: product.price * 1, discounts: 0 },
              { product_id: product.id, quantity: 1, gross_price: product.price, net_price: product.price, subtotal: product.price * 1, discounts: 0 }
            ]
          }
        end

        it "applies the promotion mechanics accordingly" do
          result = subject

          cart = result[:cart]
          expect(result[:success]).to be_truthy
          expect(cart[:transaction_date]).to eq(Date.new(2025, 5, 10))
          expect(cart[:transaction_number]).to eq(1) # Assuming this is the first cart created
          expect(cart[:gross_price]).to eq(19.5)
          expect(cart[:net_price]).to eq(19.5)
          expect(cart[:discounts]).to eq(0)
          expect(cart.cart_items.size).to eq(2)

          cart_items = cart.cart_items
          cart_item_details_subtotal = cart_items.sum { |cart_item| cart_item[:subtotal] }.to_f
          expect(cart_item_details_subtotal).to eq(cart[:gross_price].to_f)
        end
      end

      context "with a buy more pay for a fraction" do
        let!(:product) { create(:product, name: "Coffee", description: "Strong and angry", price: 11.23) }
        let!(:promo) { create(:promo, name: "Buy more, Pay for a fraction", code: "BMPF", description: "Yet another buy more fruit less all", promo_type: Promo.promo_types[:buy_more_pay_for_a_fraction]) }
        let!(:promo_detail) { create(:promo_detail, promo:, product:, pricing_mechanic:, quantity_trigger:) }
        let(:pricing_mechanic) { "7.48" }
        let(:quantity_trigger) { 3 }
        let(:params) do
          {
            cart_items: [
              { product_id: product.id, quantity: 1, gross_price: product.price, net_price: product.price, subtotal: product.price * 1, discounts: 0 },
              { product_id: product.id, quantity: 1, gross_price: product.price, net_price: product.price, subtotal: product.price * 1, discounts: 0 },
              { product_id: product.id, quantity: 1, gross_price: product.price, net_price: product.price, subtotal: product.price * 1, discounts: 0 },
              { product_id: product.id, quantity: 1, gross_price: product.price, net_price: product.price, subtotal: product.price * 1, discounts: 0 }
            ]
          }
        end

        it "applies the promotion mechanics accordingly" do
          result = subject

          cart = result[:cart]
          expect(result[:success]).to be_truthy
          expect(cart[:transaction_date]).to eq(Date.new(2025, 5, 10))
          expect(cart[:transaction_number]).to eq(1) # Assuming this is the first cart created
          expect(cart[:gross_price]).to eq(BigDecimal("29.92"))
          expect(cart[:net_price]).to eq(BigDecimal("29.92"))
          expect(cart[:discounts]).to eq(0)
          expect(cart.cart_items.size).to eq(1)
        end
      end
    end
  end
end
