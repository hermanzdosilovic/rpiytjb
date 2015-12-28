Rails.application.routes.draw do
  namespace :api do
    api version: 1, module: 'v1', allow_prefix: 'v' do
      get 'play', to: 'base#play'
    end
  end
end
