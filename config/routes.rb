Rails.application.routes.draw do
  namespace :api do
      get 'start', to: 'videos#start'
      get 'stop', to: 'videos#stop'
      get 'pause', to: 'videos#pause'
      get 'volume', to: 'videos#volume'
      get 'now', to: 'videos#now'
      get 'force_stop', to: 'videos#force_stop'
  end
end
