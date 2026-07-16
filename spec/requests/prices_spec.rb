require "rails_helper"

RSpec.describe "Prices API", type: :request do
  it "returns cached price" do
    Rails.cache.write("crypto_price:BTC", 60000)

    get "/prices/BTC"

    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)["price"]).to eq(60000)
  end

  it "returns 404 if not cached" do
    get "/prices/UNKNOWN"

    expect(response).to have_http_status(:not_found)
  end
end