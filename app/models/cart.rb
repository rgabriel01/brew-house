# == Schema Information
#
# Table name: carts
#
#  id               :integer          not null, primary key
#  discounts        :decimal(10, 2)   not null
#  gross_price      :decimal(10, 2)   not null
#  net_price        :decimal(10, 2)   not null
#  transaction_date :date
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Cart < ApplicationRecord
  validates :transaction_date, :gross_price, :net_price, :discounts, presence: true

  has_many :cart_items, dependent: :destroy
end
