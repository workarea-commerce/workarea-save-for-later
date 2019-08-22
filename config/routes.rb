Workarea::Storefront::Engine.routes.draw do
  scope '(:locale)', constraints: Workarea::I18n.routes_constraint do
    resources :saved_list_items, only: [:create, :destroy]
  end
end
