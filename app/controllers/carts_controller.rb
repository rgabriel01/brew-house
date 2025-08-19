class CartsController < ApplicationController
  before_action :set_product, only: [ :create, :update ]
  before_action :set_cart_params, only: [ :create ]
  before_action :set_cart, only: [ :show, :update ]

  def index
    @products = Product.all
    @cart = Cart.new
  end

  def create
    if @product.nil?
      return redirect_to carts_path, alert: "Product not found."
    end

    result = Carts::CreateService.call(params: @cart_params)
    if result[:success]
      redirect_to cart_path(result[:cart]), notice: "Cart was successfully created."
    else
      redirect_to carts_path, alert: "Failed to create cart."
    end
  end

  def show
    @total_subtotal = @cart.cart_items.sum(&:subtotal)
  end

  def update
    if @product.nil?
      return redirect_to cart_path(@cart), alert: "Product not found."
    end

    cart_items_hash = Carts::AddItemToCartItemsService.call(params: update_params)
    result = Carts::UpdateService.call(params: { cart_items: cart_items_hash, id: @cart.id })

    if result[:success]
      redirect_to cart_path(result[:cart]), notice: "Cart was successfully updated."
    else
      redirect_to carts_path, alert: "Failed to update cart."
    end
  end

  private

  def update_params
    return {} if @product.nil?

    {
      id: params[:id],
      updating_cart_item: {
        product_id: @product.id,
        quantity: params[:cart][:quantity].to_i,
        gross_price: @product.price,
        net_price: @product.price,
        subtotal: @product.price * params[:cart][:quantity].to_i,
        discounts: 0
      }
    }
  end

  def set_cart
    @cart = Cart.includes(cart_items: :product).find(params[:id])
  end

  def set_product
    @product = Products::FindService.call(barcode: params[:cart][:barcode])
  end

  def set_cart_params
    return [] unless @product

    @cart_params = {
      cart_items: [
        {
          product_id: @product.id,
          quantity: params[:cart][:quantity].to_i,
          gross_price: @product.price,
          net_price: @product.price,
          subtotal: @product.price * params[:cart][:quantity].to_i,
          discounts: 0
        }
      ]
    }
  end
end
