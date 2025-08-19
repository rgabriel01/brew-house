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
    buy_one_get_one: "buy_one_get_one",
    buy_more_pay_less: "buy_more_pay_less",
    buy_more_pay_for_a_fraction: "buy_more_pay_for_a_fraction"
  }, _prefix: true
end
