require 'rails_helper'

describe "Items API" do
  before :each do
    Merchant.destroy_all
    Item.destroy_all
  end
  it "sends a list of items" do
    create_list(:item, 3)

    get '/api/v1/items'

    expect(response).to be_successful

    items = JSON.parse(response.body, symbolize_names: true)

    expect(items[:data].length).to eq(3)
  end

  it "can get one item by its id" do
    id = create(:item).id
    get "/api/v1/items/#{id}"

    item = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(item[:data][:id].to_i).to eq(id)
  end

  it "can create a new item" do
    Merchant.destroy_all
    merchant = create(:merchant)

    item_params = { name: "New Item",
                  description: "An Item",
                  unit_price: 5,
                  merchant_id: merchant.id}

    post "/api/v1/items", params: item_params
    item = Item.last

    expect(response).to be_successful

    expect(item.name).to eq(item_params[:name])
  end

  it "can update an existing item" do
    id = create(:item).id
    previous_name = Item.last.name
    item_params = { name: "Sledge" }

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

  it "can get the merchant associated with an item" do
    merchant_1 = create(:merchant)
    item_1 = create(:item)

    merchant_1.items << item_1

    last_item = Item.last

    get "/api/v1/items/#{last_item.id}/merchant"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(merchant[:data][:id]).to eq(merchant_1.id.to_s)
  end
end
