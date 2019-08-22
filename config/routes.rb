Workarea::Storefront::Engine.routes.draw do
  scope '(:locale)', constraints: Workarea::I18n.routes_constraint do
    resources :saved_list_items, only: [:create, :destroy]

    post 'analytics/saved_list_add/:product_id', to: 'analytics#saved_list_add', as: :analytics_saved_list_add
    post 'analytics/saved_list_remove/:product_id', to: 'analytics#saved_list_remove', as: :analytics_saved_list_remove
  end
end

Workarea::Admin::Engine.routes.draw do
  scope '(:locale)', constraints: Workarea::I18n.routes_constraint do
    resource :report, only: [] do
      get :save_for_later_products
    end
  end
end
