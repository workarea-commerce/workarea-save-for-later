require 'test_helper'

module Workarea
  module Storefront
    class CurrentSavedListIntegrationTest < Workarea::IntegrationTest
      setup :product, :user

      def product
        @product ||= create_product
      end

      def user
        @user ||= create_user(
          email: 'test@workarea.com',
          password: 'W3bl1nc!'
        )
      end

      def test_current_saved_list
        post storefront.cart_items_path,
             params: {
               product_id: product.id,
               sku: product.skus.first,
               quantity: 3,
             }

        get storefront.cart_path

        refute(cookies[:saved_list_id].present?)

        order = Order.first
        item = order.items.first

        post storefront.saved_list_items_path,
             params: {
               product_id: item.product_id,
               sku: item.sku,
               quantity: item.quantity,
               cart_item_id: item.id
             }

        assert(cookies[:saved_list_id].present?)

        list = SavedList.find(cookies[:saved_list_id])
        assert_equal(1, list.items.count)

        post storefront.login_path,
          params: {
            email: 'test@workarea.com',
            password: 'W3bl1nc!'
          }

        refute(cookies[:saved_list_id].present?)

        assert_raises(Mongoid::Errors::DocumentNotFound) { list.reload }

        list = SavedList.find_by(user_id: user.id.to_s)
        assert_equal(1, list.items.count)
      end
    end
  end
end
