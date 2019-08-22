require 'test_helper'

module Workarea
  module Storefront
    class SavedListItemsIntegrationTest < Workarea::IntegrationTest
      include CatalogCustomizationTestClass

      setup :product, :saved_list

      def product
        @product ||= create_product(customizations: 'foo_cust')
      end

      def saved_list
        @saved_list ||= create_saved_list.tap do |list|
          cookies[:saved_list_id] = list.id.to_s
        end
      end

      def test_create
        post storefront.saved_list_items_path,
             params: {
               product_id: product.id,
               sku: product.skus.first,
               quantity: 2,
               customizations: { foo: 'test', bar: 'baz' }.to_json
             }

        assert_redirected_to(storefront.cart_path)

        saved_list.reload
        item = saved_list.items.first
        assert_equal(product.id, item.product_id)
        assert_equal(product.skus.first, item.sku)
        assert_equal(2, item.quantity)
        assert_equal({ 'foo' => 'test', 'bar' => 'baz' }, item.customizations)
      end

      def test_create_from_order_item
        post storefront.cart_items_path,
             params: {
               product_id: product.id,
               sku: product.skus.first,
               quantity: 3,
               customizations: { foo: 'test', bar: 'baz' }
             }

        order = Order.first
        item = order.items.first

        post storefront.saved_list_items_path,
             params: {
               product_id: item.product_id,
               sku: item.sku,
               quantity: item.quantity,
               customizations: { foo: 'test', bar: 'baz' }.to_json,
               cart_item_id: item.id
             }

        assert_redirected_to(storefront.cart_path)

        saved_list.reload
        item = saved_list.items.first
        assert_equal(product.id, item.product_id)
        assert_equal(product.skus.first, item.sku)
        assert_equal(3, item.quantity)
        assert_equal({ 'foo' => 'test', 'bar' => 'baz' }, item.customizations)

        order.reload
        assert_equal(0, order.items.count)
      end

      def test_create_with_invalid_customizations
        post storefront.saved_list_items_path,
             params: {
               product_id: product.id,
               sku: product.skus.first,
               quantity: 2,
               customizations: { foo: 'test' }.to_json
             }

      assert_redirected_to(storefront.cart_path)
        assert_equal(
          t('workarea.storefront.saved_lists.flash_messages.error'),
          flash[:error]
        )

        saved_list.reload
        assert_equal(0, saved_list.items.count)
      end

      def test_destroy
        saved_list.items.create!(
          product_id: product.id,
          sku: product.skus.first,
        )

        delete storefront.saved_list_item_path(saved_list.items.first.id)

        assert_redirected_to(storefront.cart_path)

        saved_list.reload
        assert_equal(0, saved_list.items.count)
      end
    end
  end
end
