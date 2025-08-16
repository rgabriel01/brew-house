module Carts
  class CreateService
    attr_reader :cart_items

    def self.call(params: {})
      new(params:).call
    end

    def initialize(params: {})
      @cart_items = params.delete(:cart_items)
    end

    def call
      cart = Cart.create(
        transaction_date: Date.today,
        gross_price: gross_price,
        net_price: net_price,
        discounts: discounts,
        cart_items_attributes: cart_items
      )

      cart.errors.any? ? { success: false, errors: cart.errors.full_messages } : { success: true, cart: cart }
    end

    private

    def gross_price
      @gross_price ||= cart_items.sum { |item| item[:gross_price] * item[:quantity] }
    end

    def net_price
      @net_price ||= cart_items.sum { |item| item[:net_price] * item[:quantity] }
    end

    def discounts
      @discounts ||= cart_items.sum { |item| item[:discounts] || 0 }
    end
  end
end
