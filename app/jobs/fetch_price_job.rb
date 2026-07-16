class FetchPriceJob < ApplicationJob
  queue_as :default

  SYMBOLS = %w[BTC ETH]

  def perform
    SYMBOLS.each do |symbol|
      fetch_and_store(symbol)
    end
  end

  private

  def fetch_and_store(symbol)
    response = HTTParty.get("https://api.coingecko.com/api/v3/simple/price?ids=#{map_symbol(symbol)}&vs_currencies=usd")

    price = response.dig(map_symbol(symbol), "usd")

    if price
      Rails.cache.write(cache_key(symbol), price, expires_in: 5.minutes)
    end

  rescue => e
    Rails.logger.error("Failed to fetch #{symbol}: #{e.message}")
    # fallback → do nothing (keep old cache)
  end

  def cache_key(symbol)
    "crypto_price:#{symbol}"
  end

  def map_symbol(symbol)
    {
      "BTC" => "bitcoin",
      "ETH" => "ethereum"
    }[symbol]
  end
end