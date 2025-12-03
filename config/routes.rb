Rails.application.routes.draw do
  # Users
  post "/users", to: "users#create"

  # Sessions
  post "/sessions", to: "sessions#create"
  get "/authenticated", to: "sessions#authenticated"
  delete "/sessions", to: "sessions#destroy"

  # Tweets
  post "/tweets", to: "tweets#create"
  get "/tweets", to: "tweets#index"
  delete "/tweets/:id", to: "tweets#destroy"
  get "/users/:username/tweets", to: "tweets#index_by_user"
end

