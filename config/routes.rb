Rails.application.routes.draw do
  namespace :api do
      get 'play', to: 'base#play'
      get 'stop', to: 'base#stop'
  end
end
