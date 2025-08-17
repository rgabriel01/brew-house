FactoryBot.define do
  factory :promo do
    code { "SUMMERSALE" }
    name { "Summer Sale" }
    promo_type { Promo.promo_types[:buy_one_get_one] }
    description { "It's that time of the year again, bring out your towels and sunscreen!" }
  end
end
