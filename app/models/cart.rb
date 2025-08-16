# == Schema Information
#
# Table name: carts
#
#  id                 :integer          not null, primary key
#  discounts          :decimal(10, 2)   not null
#  gross_price        :decimal(10, 2)   not null
#  net_price          :decimal(10, 2)   not null
#  transaction_date   :date
#  transaction_number :integer          not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class Cart < ApplicationRecord
  before_create :set_transaction_number

  validates :transaction_date, :gross_price, :net_price, :discounts, presence: true

  has_many :cart_items, dependent: :destroy

  accepts_nested_attributes_for :cart_items, allow_destroy: true

  private

  def set_transaction_number
    self.transaction_number = Cart.maximum(:transaction_number).to_i + 1
  end
end
