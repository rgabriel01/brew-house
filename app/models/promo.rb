# == Schema Information
#
# Table name: promos
#
#  id          :integer          not null, primary key
#  code        :string           not null
#  description :text
#  name        :string           not null
#  promo_type  :string           not null
#  status      :string           default("active"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Promo < ApplicationRecord
  validates :name, :code, :promo_type, presence: true
  validates :code, uniqueness: true

  has_many :promo_details, dependent: :destroy

  scope :active, -> { where(status: :active) }

  enum status: {
    active: "active",
    inactive: "inactive"
  }, _prefix: true

  enum promo_type: {
    buy_one_get_one: "BUY_ONE_GET_ONE",
    buy_more_pay_less: "BUY_MORE_PAY_LESS",
    buy_more_pay_for_fraction: "BUY_MORE_PAY_FOR_A_FRACTION"
  }, _prefix: true
end
