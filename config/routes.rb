Rails.application.routes.draw do
  namespace :api do
      get 'play', to: 'videos#play'
      get 'stop', to: 'videos#stop'
  end
end
