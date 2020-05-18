FactoryBot.define do
  factory :item do
    merchant_1 = Merchant.create!(name: "Merchant 1")
    name { "Item 3" }
    description { "An Item" }
    unit_price { 7 }
    merchant_id { merchant_1.id }
  end
end
