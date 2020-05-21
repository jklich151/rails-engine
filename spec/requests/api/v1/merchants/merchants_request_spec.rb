require 'rails_helper'

describe "Merchants API" do
  before :each do
    Merchant.destroy_all
    Item.destroy_all
  end
  it "sends a list of merchants" do
    create_list(:merchant, 3)

    get '/api/v1/merchants'

    expect(response).to be_successful

    merchants = JSON.parse(response.body, symbolize_names: true)

    expect(merchants[:data].length).to eq(3)
  end

  it "can get one merchant by its id" do
    id = create(:merchant).id

    get "/api/v1/merchants/#{id}"

    merchant = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(merchant[:data][:id].to_i).to eq(id)
  end

  it "can create a new merchant" do
    merchant_params = { name: "Nordstrom" }

    post "/api/v1/merchants", params: {merchant: merchant_params}
    merchant = Merchant.last

    expect(response).to be_successful

    expect(merchant.name).to eq(merchant_params[:name])
  end

  it "can update an existing merchant" do
    id = create(:merchant).id
    previous_name = Merchant.last.name
    merchant_params = { name: "Target" }

    put "/api/v1/merchants/#{id}", params: {merchant: merchant_params}
    merchant = Merchant.find_by(id: id)

    expect(response).to be_successful

    expect(merchant.name).to_not eq(previous_name)
    expect(merchant.name).to eq("Target")
  end

  it "can destroy a merchant" do
    merchant = create(:merchant)

    expect(Merchant.count).to eq(1)

    delete "/api/v1/merchants/#{merchant.id}"

    expect(response).to be_successful

    expect(Merchant.count).to eq(0)
    expect{Merchant.find(merchant.id)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "can get all items from one merchant" do
    merchant_1 = create(:merchant)
    item_1 = create(:item)
    item_2 = create(:item)
    item_3 = create(:item)

    merchant_1.items << item_1
    merchant_1.items << item_2
    merchant_1.items << item_3

    get "/api/v1/merchants/#{merchant_1.id}/items"

    items = JSON.parse(response.body, symbolize_names: true)

    expect(response).to be_successful

    expect(items[:data].length).to eq(3)
  end
end
