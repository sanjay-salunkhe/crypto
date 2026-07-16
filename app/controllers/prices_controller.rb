class PricesController < ApplicationController
  def show
    symbol = params[:symbol].upcase

    price = Rails.cache.read(cache_key(symbol))

    if price
      render json: { symbol: symbol, price: price, source: "cache" }
    else
      render json: { error: "Price not available" }, status: :not_found
    end
  end

  private

  def cache_key(symbol)
    "crypto_price:#{symbol}"
  end
end