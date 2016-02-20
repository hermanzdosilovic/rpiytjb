Rails.application.routes.draw do
  namespace :api do
      get 'force_stop', to: 'videos#force_stop'
      get 'now', to: 'videos#now'
      get 'pause', to: 'videos#pause'
      get 'start', to: 'videos#start'
      get 'radio', to: 'videos#radio'
      get 'stop', to: 'videos#stop'
      get 'volume', to: 'videos#volume'
      get 'position', to: 'videos#position'
  end
end
