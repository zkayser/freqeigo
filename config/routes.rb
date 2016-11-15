Rails.application.routes.draw do
  
  root "home#home"
  get 'home/learn'
  devise_for :users, controller: { sessions: "users/session" }
  resources :users, only: [:show, :edit, :index] do
    resource :calendar, only: [:edit, :show, :update, :destroy] do
      get '/(:month)/(:year)', to: "calendars#show", as: "user_calendar"
    end
  end
  resources :word_lists, :courses, :words, :decks, :textbooks, :blogs, :payments, :registrations, :subscriptions, :payment_notifications,
            :plans, :charges
  shallow do
    resources :categories do
      resources :subcategories
    end
  end
  resources :example_sentences do
    get :words, on: :member
  end
  get 'hiragana_convert', to: "example_sentences#hiragana_convert"
  get 'subcategories/:subcategory_id/decks', to: "decks#subcategory_index", as: "subcategory_decks"
  get 'subcategories/:subcategory_id/decks/:id', to: "decks#subcategory_show", as: "subcategory_deck_show"
  post 'subcategories/:subcategory_id/decks', to: "decks#subcategory_deck_create", as: "subcategory_deck_create"
  post 'stripe_webhooks', to: "webhooks#stripe_event", as: "webhooks"
  get 'stripe_webhooks', to: "webhooks#index", as: "webhooks_index"
  get 'customers', to: "customers#index", as: "customers"
  post 'registrations/paypal_notifications', to: "registrations#paypal_notifications", as: "paypal_notification"
  get 'cards/new', to: "cards#new", as: "new_card"
  post 'cards/create', to: "cards#create"
  patch 'decks/(:deck_id)/cards/(:id)/successful_review', to: "cards#successful_review", as: "successful_review"
  patch 'decks/(:deck_id)/cards/(:id)/unsuccessful_review', to: "cards#unsuccessful_review", as: "unsuccessful_review"
  get 'vocab_list/(:page)', to: "words#vocab_list", as: "vocab_list"
  get 'users/show'
  get 'users/edit'
  get 'admin_panel/:user', to: 'users#admin_panel', as: "admin_panel"
  get ':user/decks', to: 'users#deck_index', as: 'user_decks'
  get ':user/decks/:deck', to: 'users#deck_show', as: 'user_deck'
  get 'enrollments/enroll'
  post 'enrollments/:course_id', to: 'enrollments#enroll', as: 'user_enrollment'
  get 'course/:id/word_list/(:page)', to: 'courses#study_word_list', as: 'study_word_list'
  post 'course/:word_list/deckify/:user', to: "word_lists#deckify", as: "deckify_word_list"
  post 'course/:word_list/custom_deckify/:user', to: "word_lists#custom_deckify", as: "custom_deckify"
  post 'example_sentences/:word', to: "example_sentences#create", as: "create_example_sentences" # This will probably cause a problem when you nest the root with words
  post 'user_deck_create', to: "users#user_deck_create", as: "user_deck_create"
  delete 'cards/:card', to: "cards#destroy", as: "card"
  get 'cards/edit/:card', to: "cards#edit", as: "edit_card"
  post 'decks/edit/:deck', to: "decks#multi_delete", as: "deck_multi_delete"
  get 'decks/:deck/card/new', to: "decks#new_card", as: "new_deck_card"
  get 'decks/:deck/:card/edit', to: "decks#edit_card", as: "edit_deck_card"
  post 'decks/cards', to: "cards#create", as: "cards"
  patch 'deck/cards', to: "cards#update", as: "edit_cards"
  get ':user/deck/new', to: "users#new_deck", as: "new_user_deck"
  post 'users/decks', to: "users#create_new_deck", as: "create_new_user_deck"
  post 'hiragana_convert/convert', to: "example_sentences#convert"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
