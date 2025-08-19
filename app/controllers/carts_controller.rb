class CartsController < ApplicationController
  before_action :set_product, :set_cart_params, only: [ :create, :update ]
  before_action :set_cart, only: [ :show, :update ]

  def index
    @products = Product.all
  end

  def create
    result = Carts::CreateService.call(params: @cart_params)
    if result[:success]
      redirect_to cart_path(result[:cart]), notice: "Cart was successfully created."
    else
      redirect_to carts_path, alert: "Failed to create cart."
    end
  end

  def show
  end

  def update
  end

  private

  def set_cart
    @cart = Cart.includes(cart_items: :product).find(params[:id])
    @total_subtotal = @cart.cart_items.sum(&:subtotal)
  end

  def set_product
    @product = Products::FindService.call(barcode: params[:barcode])
  end

  def set_cart_params
    @cart_params = {
      cart_items: [
        {
          product_id: @product.id,
          quantity: params[:quantity].to_i,
          gross_price: @product.price,
          net_price: @product.price,
          subtotal: @product.price * params[:quantity].to_i,
          discounts: 0
        }
      ]
    }
  end
end
