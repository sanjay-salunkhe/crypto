# Crypto Price API

This is a small Rails API that returns cryptocurrency prices for a given symbol.

The system periodically fetches prices from an external API and stores them locally.  
The API serves cached data for fast responses and falls back to stored data if needed.

---

## Problem Statement

Build an API:

GET /prices/:symbol

- Returns the latest price for a given crypto symbol
- Uses cached data when available
- Falls back to last stored value if external API fails

---

## Approach

- A background job runs every minute
- It fetches the latest price from CoinGecko
- Stores the price in:
  - Database (persistent storage)
  - Cache (Redis for fast access)

When API is called:
1. Try cache (Redis)
2. If not found → read from DB
3. If not found → return error

---

## Tech Stack

- Ruby on Rails (API mode)
- PostgreSQL
- Redis (caching + background jobs)
- Sidekiq (job processing)
- RSpec (testing)
- Docker & Docker Compose

---

## Setup (Using Docker) 🚀

### Build containers

docker compose build

### Start services

docker compose up

This will start:
- Rails API (web)
- PostgreSQL (db)
- Redis
- Sidekiq

---

### Setup database (first time only)

docker compose exec web rails db:create  
docker compose exec web rails db:migrate  

---

### API will be available at:

http://localhost:3000

---

## Setup (Without Docker)

### Install dependencies

bundle install

### Setup database

rails db:create  
rails db:migrate  

### Start Redis

redis-server

### Start Sidekiq

bundle exec sidekiq

### Start server

rails s

---

## API Usage

### Request

GET /prices/:symbol

Example:

GET /prices/bitcoin

---

### Response

From cache:

{
  "symbol": "bitcoin",
  "price": 64000.25,
  "source": "cache"
}

Fallback to DB:

{
  "symbol": "bitcoin",
  "price": 64000.25,
  "source": "db"
}

---

## Failure Handling

- If external API fails:
  - System does not crash
  - Last stored price is returned
- If no data exists:
  - Returns error response

---

## Notes / Assumptions

- Symbol is expected in lowercase (e.g. bitcoin)
- Cache expiry is short (around 2 minutes)
- Background job keeps data updated
- Redis is used for caching and Sidekiq jobs

---

## Summary

- DB → source of truth  
- Cache → fast reads  
- Background job → keeps data updated  
- Docker → easy setup and consistent environment