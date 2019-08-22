require 'test_helper'

module Workarea
  module Storefront
    class SaveForLaterSystemTest < Workarea::SystemTest
      def test_managing_saved_list
        product = create_product
        inventory = create_inventory(
          id: product.skus.first,
          policy: :standard,
          available: 10
        )

        visit storefront.product_path(product)
        click_button t('workarea.storefront.products.add_to_cart')

        visit storefront.cart_path

        assert(page.has_no_content?(t('workarea.storefront.carts.empty')))
        assert(page.has_no_content?(t('workarea.storefront.saved_lists.title')))
        assert(page.has_content?(product.name))
        assert(page.has_content?(product.skus.first))

        click_button t('workarea.storefront.carts.save_for_later')

        assert(page.has_content?('Success'))

        assert(page.has_content?(t('workarea.storefront.carts.empty')))
        assert(page.has_content?(t('workarea.storefront.saved_lists.title')))
        assert(page.has_content?(product.name))
        assert(page.has_content?(product.skus.first))
        assert(page.has_content?(t('workarea.storefront.products.in_stock')))

        click_button t('workarea.storefront.saved_lists.move_to_cart')

        assert(page.has_no_content?(t('workarea.storefront.carts.empty')))
        assert(page.has_no_content?(t('workarea.storefront.saved_lists.title')))
        assert(page.has_content?(product.name))
        assert(page.has_content?(product.skus.first))

        inventory.update(available: 0)

        click_button t('workarea.storefront.carts.save_for_later')

        assert(page.has_content?('Success'))
        assert(page.has_content?(t('workarea.storefront.products.out_of_stock')))
        assert(page.has_no_content?(t('workarea.storefront.saved_lists.move_to_cart')))
        assert(page.has_content?(t('workarea.storefront.products.unavailable')))

        click_link t('workarea.storefront.saved_lists.remove')

        assert(page.has_content?('Success'))

        assert(page.has_content?(t('workarea.storefront.carts.empty')))
        assert(page.has_no_content?(t('workarea.storefront.saved_lists.title')))
      end
    end
  end
end
