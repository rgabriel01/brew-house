module Products
  class FindService
    attr_reader :barcode

    def self.call(barcode: "")
      new(barcode:).call
    end

    def initialize(barcode: "")
      @barcode = barcode
    end

    def call
      Product.find_by(barcode:)
    end
  end
end
