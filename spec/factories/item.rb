FactoryBot.define do
  factory :item do
    name { Faker::TvShows::Friends.character }
    description { Faker::TvShows::Friends.quote}
    unit_price { rand(1.00..99.99).round(2) }
    merchant
  end
end
