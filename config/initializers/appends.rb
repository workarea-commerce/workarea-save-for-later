Workarea.append_partials(
  'storefront.cart_show',
  'workarea/storefront/carts/saved_for_later'
)

Workarea.append_partials(
  'storefront.cart_item_actions',
  'workarea/storefront/carts/save_for_later_button'
)

Workarea.append_stylesheets(
  'storefront.components',
  'workarea/storefront/save_for_later/components/product_prices'
)

Workarea.append_javascripts(
  'storefront.modules',
  'workarea/storefront/save_for_later/modules/saved_list_analytics'
)

Workarea.append_partials(
  'admin.reports_dashboard',
  'workarea/admin/dashboards/save_for_later_products_card'
)
