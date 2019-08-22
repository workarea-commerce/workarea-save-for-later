require 'test_helper'

module Workarea
  module Insights
    class MostSavedProductsTest < TestCase
      setup :add_data, :time_travel

      def add_data
        Metrics::ProductByDay.inc(
          key: { product_id: 'foo' },
          at: Time.zone.local(2018, 10, 27),
          saved_list_adds: 1
        )

        Metrics::ProductByDay.inc(
          key: { product_id: 'foo' },
          at: Time.zone.local(2018, 10, 28),
          saved_list_adds: 2
        )

        Metrics::ProductByDay.inc(
          key: { product_id: 'foo' },
          at: Time.zone.local(2018, 10, 29),
          saved_list_adds: 3
        )

        Metrics::ProductByDay.inc(
          key: { product_id: 'bar' },
          at: Time.zone.local(2018, 10, 27),
          saved_list_adds: 3
        )

        Metrics::ProductByDay.inc(
          key: { product_id: 'bar' },
          at: Time.zone.local(2018, 10, 28),
          saved_list_adds: 4
        )

        Metrics::ProductByDay.inc(
          key: { product_id: 'bar' },
          at: Time.zone.local(2018, 10, 29),
          saved_list_adds: 5
        )
      end

      def time_travel
        travel_to Time.zone.local(2018, 11, 1)
      end

      def test_generate_monthly!
        MostSavedProducts.generate_monthly!
        assert_equal(1, MostSavedProducts.count)

        saved_products = MostSavedProducts.first
        assert_equal(2, saved_products.results.size)
        assert_equal('bar', saved_products.results.first['product_id'])
        assert_in_delta(12, saved_products.results.first['adds'])
        assert_equal('foo', saved_products.results.second['product_id'])
        assert_in_delta(6, saved_products.results.second['adds'])
      end
    end
  end
end
