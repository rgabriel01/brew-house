module Carts
  class CreateService
    attr_reader :cart_items_raw
    attr_accessor :cart_items

    def self.call(params: {})
      new(params:).call
    end

    def initialize(params: {})
      @cart_items_raw = params.delete(:cart_items)
    end

    def call
      @cart_items = consolidate_cart_items

      cart = Cart.create(
        transaction_date: Date.today,
        gross_price: gross_price,
        net_price: net_price,
        discounts: discounts,
        cart_items_attributes: cart_items
      )

      return { success: false, errors: cart.errors.full_messages } if cart.errors.any?

      # evaluate the cart for promotions
      { success: true, cart: }
    end

    private

    def gross_price
      @gross_price ||= cart_items.sum { |item| item[:gross_price] * item[:quantity] }
    end

    def net_price
      @gross_price ||= cart_items.sum { |item| item[:gross_price] * item[:quantity] }
      @net_price ||= cart_items.sum { |item| item[:net_price] * item[:quantity] }
    end

    def discounts
      @discounts ||= cart_items.sum { |item| item[:discounts] || 0 }
    end

    def consolidate_cart_items
      cart_items_raw.group_by { |item| item[:product_id] }.map do |product_id, items|
        quantity = items.sum { |item| item[:quantity] }
        gross_price = items.sum { |item| item[:gross_price] } / items.length # divide by number of items to get average gross price
        discounts = 0 # reset to 0 as we recompute this on the promo level
        net_price = gross_price - discounts
        subtotal = net_price * quantity

        {
          product_id:,
          quantity:,
          gross_price:,
          discounts:,
          net_price:,
          subtotal:
        }
      end
    end
  end
end
