# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  barcode     :string           not null
#  description :text
#  name        :string           not null
#  price       :decimal(10, 2)   not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Product < ApplicationRecord
  before_validation :set_barcode

  validates :name, :price, presence: true
  validates :barcode, presence: true, uniqueness: true

  has_many :promo_details, dependent: :destroy
  has_many :promos, through: :promo_details

  BARCODE_LENGTH = 13

  private

  def set_barcode
    if barcode.blank?
      barcode_digit = Product.maximum(:id).to_i + 1
      padding = (BARCODE_LENGTH - barcode_digit.to_s.length)
      self.barcode = "#{barcode_digit}#{'0' * padding}"
    end
  end
end
