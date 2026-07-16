require "rails_helper"

RSpec.describe FetchPriceJob, type: :job do
  let(:symbol) { "BTC" }

  before do
    Rails.cache.clear
  end

  it "stores price in cache" do
    stub_request(:get, /coingecko/)
      .to_return(body: { bitcoin: { usd: 50000 } }.to_json)

    FetchPriceJob.perform_now

    expect(Rails.cache.read("crypto_price:BTC")).to eq(50000)
  end

  it "keeps old price if API fails" do
    Rails.cache.write("crypto_price:BTC", 40000)

    stub_request(:get, /coingecko/).to_raise(StandardError)

    FetchPriceJob.perform_now

    expect(Rails.cache.read("crypto_price:BTC")).to eq(40000)
  end
end