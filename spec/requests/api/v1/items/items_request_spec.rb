require 'rails_helper'

describe "Items API" do
  it "sends a list of items" do
    Merchant.destroy_all

    merchant_1 = Merchant.create!(name: "Merchant 1")
    item_1 = Item.create!(name: "Item 1",
                        description: "This is an item",
                        unit_price: 5,
                        merchant_id: "#{merchant_1.id}")
    item_2 = Item.create!(name: "Item 2",
                        description: "This is another item",
                        unit_price: 8,
                        merchant_id: "#{merchant_1.id}")
    item_3 = Item.create!(name: "Item 3",
                        description: "Last item",
                        unit_price: 6.7,
                        merchant_id: "#{merchant_1.id}")

    merchant_1.items << item_1
    merchant_1.items << item_2
    merchant_1.items << item_3

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body)

    expect(items.count).to eq(3)
  end

  it "can get one item by its id" do
    Merchant.destroy_all

    merchant_1 = Merchant.create!(name: "Merchant 1")
    item_1 = Item.create!(name: "Item 1",
                        description: "This is an item",
                        unit_price: 5,
                        merchant_id: "#{merchant_1.id}")

    merchant_1.items << item_1

    get "/api/v1/items/#{item_1.id}"

    item = JSON.parse(response.body)

    expect(response).to be_successful

    expect(item["id"]).to eq("#{item_1.id}".to_i)
  end

  it "can create a new item" do
    Merchant.destroy_all

    merchant_1 = Merchant.create!(name: "Merchant 1")
    item_params = { name: "New Item",
                  description: "An Item",
                  unit_price: 5,
                  merchant_id: merchant_1.id}

    post "/api/v1/items", params: item_params
    item = Item.last

    expect(response).to be_successful
    expect(item.name).to eq(item_params[:name])
  end

  it "can update an existing item" do
    merchant_1 = Merchant.create!(name: "Merchant 1")
    id = create(:item).id
    previous_name = Item.last.name
    item_params = { name: "Sledge",
                    description: "something",
                    unit_price: 5,
                    merchant_id: merchant_1.id}

    put "/api/v1/items/#{id}", params: item_params
    item = Item.find_by(id: id)

    expect(response).to be_successful
    expect(item.name).to_not eq(previous_name)
    expect(item.name).to eq("Sledge")
  end

  it "can destroy an item" do
    item = create(:item)

    expect(Item.count).to eq(1)

    delete "/api/v1/items/#{item.id}"

    expect(response).to be_successful
    expect(Item.count).to eq(0)
    expect{Item.find(item.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end
end
