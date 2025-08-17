FactoryBot.define do
  factory :promo_detail do
    association :promo
    association :product
  end
end
