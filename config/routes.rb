Rails.application.routes.draw do
  namespace :api do
      get 'start', to: 'videos#start'
      get 'stop', to: 'videos#stop'
      get 'pause', to: 'videos#pause'
      post 'volume', to: 'videos#volume'
  end
end
