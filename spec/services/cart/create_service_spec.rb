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
          { product_id: product1.id, quantity: 2, gross_price: product1.price, net_price: product1.price, subtotal: product1.price * 2, discounts: 0 },
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
  end
end
