Rails.application.routes.draw do
  namespace :api do
      get 'play', to: 'base#play'
  end
end
