# frozen_string_literal: true

Rails.application.routes.draw do
  resources :posts
  # Webhooks endpoints
  post 'webhooks/ping', to: 'webhooks#ping'
  post 'webhooks/deliver', to: 'webhooks#deliver'
  post 'webhooks/deliver/:handler', to: 'webhooks#deliver'

  root 'posts#index'
end
