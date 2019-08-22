require 'test_helper'

module Workarea
  class SaveForLaterOrderMetricsTest < TestCase
    def test_products_from_saved_lists
      product_one = create_product(
        name: 'Foo 1',
        variants: [
          { sku: 'SKU1', regular: 5.to_m },
          { sku: 'SKU11', regular: 10.to_m }
        ]
      )

      product_two = create_product(
        name: 'Foo 2',
        variants: [
          { sku: 'SKU2', regular: 6.to_m },
          { sku: 'SKU22', regular: 12.to_m }
        ]
      )

      saved_list = create_saved_list(user_id: '123')

      order = create_order(
        email: 'test@workarea.com',
        items: [
          { product_id: product_one.id, sku: 'SKU1', quantity: 2, via: saved_list.to_gid_param },
          { product_id: product_one.id, sku: 'SKU11', quantity: 1, via: saved_list.to_gid_param },
          { product_id: product_two.id, sku: 'SKU2', quantity: 1 },
          { product_id: product_two.id, sku: 'SKU22', quantity: 2, via: saved_list.to_gid_param }
        ]
      )

      Pricing.perform(order)
      complete_checkout(order)

      results = OrderMetrics.new(order).products_from_saved_lists

      product_data = results[product_one.id]
      assert_equal(3, product_data[:saved_list_units_sold])
      assert_equal(20.to_m, product_data[:saved_list_revenue])

      product_data = results[product_two.id]
      assert_equal(2, product_data[:saved_list_units_sold])
      assert_equal(24.to_m, product_data[:saved_list_revenue])
    end
  end
end
