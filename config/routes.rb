require "sidekiq/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"

  get "/prices/:symbol", to: "prices#show"
end