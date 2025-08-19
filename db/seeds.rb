# seed data, one can run this idempotently

products = [
  {
    barcode: "1001",
    description: "A soothing green tea with a refreshing taste.",
    name: "Green Tea",
    price: 3.11
  },
  {
    barcode: "1002",
    description: "A sweet and tangy fruit.",
    name: "Strawberries",
    price: 5.00
  },
  {
    barcode: "1003",
    description: "A rich and bold coffee with a smooth finish.",
    name: "Coffee",
    price: 11.23
  }
]

promos = [
  {
    code: "BOGO",
    description: "Buy one get one free on selected items.",
    name: "Buy One Get One Free",
    promo_type: Promo.promo_types[:buy_one_get_one]
  },
  {
    code: "BMPL",
    description: "Buy more pay less on selected items.",
    name: "Buy More Pay Less",
    promo_type: Promo.promo_types[:buy_more_pay_less]
  },
  {
    code: "BMPF",
    description: "Buy more pay for a fraction on selected items.",
    name: "Buy More Pay For A Fraction",
    promo_type: Promo.promo_types[:buy_more_pay_for_a_fraction]
  }
]

promo_details = [
  {
    promo_code: "BOGO",
    product_barcode: "1001"
  },
  {
    promo_code: "BMPL",
    product_barcode: "1002",
    quantity_trigger: 3,
    pricing_mechanic: "4.5"
  },
  {
    promo_code: "BMPF",
    product_barcode: "1003",
    quantity_trigger: 3,
    pricing_mechanic: "7.48"
  }
]

logger = Logger.new(STDOUT)
products.each do |product|
  logger.info "SEEDING product: #{product[:name]} with barcode: #{product[:barcode]}"
  product_record = Product.find_or_initialize_by(barcode: product[:barcode])
  product_record.assign_attributes(product)
  product_record.save

  product_record.errors.full_messages.any? ? logger.error("FAILED to seed product: #{product[:name]} with barcode: #{product[:barcode]} \n") : logger.info("SUCCESSFULLY seeded product: #{product[:name]} with barcode: #{product[:barcode]} \n")
end

promos.each do |promo|
  logger.info "SEEDING promo: #{promo[:name]} with code: #{promo[:code]}"
  promo_record = Promo.find_or_initialize_by(code: promo[:code])
  promo_record.assign_attributes(promo)
  promo_record.save

  promo_record.errors.full_messages.any? ? logger.error("FAILED to seed promo: #{promo[:name]} with code: #{promo[:code]} \n") : logger.info("SUCCESSFULLY seeded promo: #{promo[:name]} with code: #{promo[:code]} \n")
end

promo_details.each do |promo_detail|
  logger.info "SEEDING promo_detail: #{promo_detail[:promo_code]} for product: #{promo_detail[:product_barcode]}"

  product = Product.find_by(barcode: promo_detail[:product_barcode])
  promo = Promo.find_by(code: promo_detail[:promo_code])

  promo_detail_record = PromoDetail.find_or_initialize_by(promo_id: promo.id, product_id: product.id)
  promo_detail_record.assign_attributes({
    product_id: product.id,
    promo_id: promo.id,
    quantity_trigger: promo_detail[:quantity_trigger],
    pricing_mechanic: promo_detail[:pricing_mechanic]
  })
  promo_detail_record.save

  promo_detail_record.errors.full_messages.any? ? logger.error("FAILED to seed promo_detail: #{promo_detail[:promo_code]} for product: #{promo_detail[:product_barcode]} \n") : logger.info("SUCCESSFULLY seeded promo_detail: #{promo_detail[:promo_code]} for product: #{promo_detail[:product_barcode]} \n")
end
