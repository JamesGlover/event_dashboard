# frozen_string_literal: true
Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'dashboards#index'

  resources :dashboards do
    resources :lines
    resource :login, only: [:show,:create,:destroy]
  end

end
