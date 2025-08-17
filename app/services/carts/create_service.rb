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

      apply_promotions if with_promotions?

      cart = Cart.create(
        transaction_date: Date.today,
        gross_price: gross_price,
        net_price: net_price,
        discounts: discounts,
        cart_items_attributes: cart_items
      )

      return { success: false, errors: cart.errors.full_messages } if cart.errors.any?

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

    def promotion_cart_items
      @promotion_cart_items ||= begin
        promo_product_ids = promotions.flat_map(&:promo_details).map(&:product_id)

        cart_items.select { |item| promo_product_ids.include?(item[:product_id]) }
      end
    end

    def with_promotions?
      promotion_cart_items.any?
    end

    def apply_promotions
      promo, promo_detail = find_promo_for_item(promotion_cart_items.first) # for now, just apply the first promo found

      case promo.promo_type
      when Promo.promo_types[:buy_one_get_one].downcase
        apply_buy_one_get_one(promo:, promo_detail:)
      else
        puts "Unknown promo type: #{promo.promo_type}"
      end
    end

    def promotions
      @promotions ||= Promo.includes(:promo_details).active
    end

    def find_promo_for_item(cart_item)
      promo_detail = promotions.flat_map(&:promo_details).find { |promo| promo.product_id == cart_item[:product_id] }
      promo = promo_detail.promo if promo_detail

      [ promo, promo_detail ]
    end

    def apply_buy_one_get_one(promo:, promo_detail:)
      promo_product_id = promo_detail.product_id
      cart_item = cart_items.find { |item| item[:product_id] == promo_product_id }
      promo_cart_item = cart_items.delete(cart_item)

      # we split the quantities into two parts: full priced and free priced
      full_priced_quantity = (promo_cart_item[:quantity].to_f / 2).round
      free_priced_quantity = promo_cart_item[:quantity] - full_priced_quantity

      # full priced items
      cart_items << {
        product_id: promo_cart_item[:product_id],
        quantity: full_priced_quantity,
        gross_price: promo_cart_item[:gross_price],
        discounts: 0,
        net_price: promo_cart_item[:gross_price],
        subtotal: promo_cart_item[:gross_price] * full_priced_quantity
      }

      # free priced items
      cart_items << {
        product_id: promo_cart_item[:product_id],
        quantity: free_priced_quantity,
        gross_price: 0,
        discounts: 0,
        net_price: 0,
        subtotal: 0
      }
    end
  end
end
