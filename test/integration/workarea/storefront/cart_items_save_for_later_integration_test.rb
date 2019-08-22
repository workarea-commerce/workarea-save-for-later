require 'test_helper'

module Workarea
  module Storefront
    class CartItemsSaveForLaterIntegrationTest < Workarea::IntegrationTest
      setup :set_product

      def set_product
        @product = create_product(
          name: 'Integration Product',
          variants: [
            { sku: 'SKU1', regular: 5.to_m },
            { sku: 'SKU2', regular: 6.to_m }
          ]
        )
      end

      def test_can_add_an_item
        list = create_saved_list(
          items: [{ product_id: @product.id, sku: @product.skus.first }]
        )
        item = list.items.first
        cookies[:saved_list_id] = list.id.to_s

        post storefront.cart_items_path,
          params: {
            product_id: item.product_id,
            sku: item.sku,
            quantity: item.quantity,
            saved_list_item_id: item.id
          }

        order = Order.first
        assert_equal(@product.id, order.items.first.product_id)
        assert_equal(@product.skus.first, order.items.first.sku)
        assert_equal(1, order.items.first.quantity)
        assert_equal(5.to_m, order.items.first.total_price)

        list.reload
        assert_equal(0, list.items.count)

        assert_redirected_to(storefront.cart_path)
      end
    end
  end
end
