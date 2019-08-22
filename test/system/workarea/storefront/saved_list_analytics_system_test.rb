require 'test_helper'

module Workarea
  module Storefront
    class SavedListAnalyticsSystemTest < Workarea::SystemTest
      include Storefront::SystemTest

      setup :product, :login_user

      def find_analytics_events(for_event: nil)
        all_events = page.evaluate_script('WORKAREA.analytics.events')

        if for_event.blank?
          all_events
        else
          all_events.select { |e| e['name'] == for_event }
        end
      end

      def disable_dom_events
        page.execute_script('WORKAREA.analytics.disableDomEvents();')
      end

      def product
        @product ||= create_product(name: 'Test Product')
      end

      def login_user
        @user ||= create_user(email: 'test@workarea.com', password: 'W3bl1nc!')

        visit storefront.login_path

        within '#login_form' do
          fill_in 'email', with: 'test@workarea.com'
          fill_in 'password', with: 'W3bl1nc!'
          click_button t('workarea.storefront.users.login')
        end
      end

      def test_announcing_add_to_saved_list_event
        visit storefront.product_path(product)
        click_button t('workarea.storefront.products.add_to_cart')

        visit storefront.cart_path

        disable_dom_events
        click_button t('workarea.storefront.carts.save_for_later')

        events = find_analytics_events(for_event: 'addToSavedList')
        assert_equal(1, events.count)
        payload = events.first['arguments'].first

        assert_equal(product.id, payload['id'])
        assert_equal('Test Product', payload['name'])
      end

      def test_announcing_remove_from_saved_list_event
        visit storefront.product_path(product)
        click_button t('workarea.storefront.products.add_to_cart')

        visit storefront.cart_path
        click_button t('workarea.storefront.carts.save_for_later')

        disable_dom_events
        click_button t('workarea.storefront.saved_lists.remove')

        events = find_analytics_events(for_event: 'removeFromSavedList')
        assert_equal(1, events.count)
        payload = events.first['arguments'].first

        assert_equal(product.id, payload['id'])
        assert_equal('Test Product', payload['name'])
      end
    end
  end
end
