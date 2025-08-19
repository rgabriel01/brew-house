# accepts new cart_item parameters
# reconstructs the cart_items array and adds the new item

module Carts
  class AddItemToCartItemsService
    attr_reader :cart_id, :updating_cart_item

    def self.call(params:)
      new(params:).call
    end

    def initialize(params: {})
      @cart_id = params.delete(:id)
      @updating_cart_item = params.delete(:updating_cart_item)
    end

    def call
      cart_item_hash = build_cart_item_hash
    end

    private

    def cart
      @cart ||= Cart.includes(cart_items: :product).find(cart_id)
    end

    def build_cart_item_hash
      new_cart_items = []
      cart_items = cart.cart_items

      # build from the already existing ones from the cart
      cart_items.each do |cart_item|
        product = cart_item.product

        new_cart_items << {
          product_id: cart_item.product_id,
          quantity: cart_item.quantity,
          gross_price: product.price,
          net_price: product.price,
          subtotal: product.price * cart_item.quantity,
          discounts: 0
        }
      end

      if updating_cart_item.present?
        new_cart_items << {
          product_id: updating_cart_item[:product_id],
          quantity: updating_cart_item[:quantity],
          gross_price: updating_cart_item[:gross_price],
          net_price: updating_cart_item[:net_price],
          subtotal: updating_cart_item[:net_price],
          discounts: 0
        }
      end

      new_cart_items
    end
  end
end
