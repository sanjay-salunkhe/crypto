# 🚀 Crypto Price API

This is a small Rails API that returns cryptocurrency prices for a given symbol.

The system periodically fetches prices from an external API and stores them in cache.  
The API serves cached data and continues to return the last known value even if the external API fails.

---

## 📌 Problem Statement

Build an API:

GET /prices/:symbol

- Returns the latest price for a given crypto symbol  
- Uses cached data for fast responses  
- If external API fails → continues serving last known cached value  

---

## 🧠 Approach

- A background job runs every minute  
- It fetches the latest price from CoinGecko  
- Stores the price in:
  - Redis cache (single source for reads)

### Request Flow

1. Read from cache (Redis)  
2. If present → return value  
3. If not present → return error  

---

## ⚡ Key Design Decision

No database fallback is used

- Redis acts as the **single source of truth for current price**
- Fallback works by **not overwriting cache on API failure**
- Last successful value remains available

---

## 🧰 Tech Stack

- Ruby on Rails (API mode)  
- Redis (caching + background jobs)  
- Sidekiq (job processing)  
- RSpec (testing)  
- Docker Compose  

---

## 🐳 Setup (Using Docker)

### Build containers

docker compose build

### Start services

docker compose up

This will start:

- Rails API (web)  
- Redis  
- Sidekiq  

---

## 🔧 Setup (Without Docker)

### Install dependencies

bundle install

### Start Redis

redis-server

### Start Sidekiq

bundle exec sidekiq

### Start Rails server

rails s

---

## 🌐 API Usage

### Request

GET /prices/:symbol

Example:

GET /prices/BTC

---

### ✅ Response (from cache)

```json
{
  "symbol": "BTC",
  "price": 64000.25,
  "source": "cache"
}