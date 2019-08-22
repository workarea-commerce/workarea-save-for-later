require 'test_helper'

module Workarea
  module Reports
    class SaveForLaterProductsTest < TestCase
      setup :add_data, :time_travel

      def add_data
        Metrics::ProductByDay.inc(
          key: { product_id: 'foo' },
          at: Time.zone.local(2018, 10, 27),
          saved_list_units_sold: 2,
          saved_list_revenue: 10.to_m,
          saved_list_adds: 2,
          saved_list_deletes: 1
        )

        Metrics::ProductByDay.inc(
          key: { product_id: 'foo' },
          at: Time.zone.local(2018, 10, 28),
          saved_list_units_sold: 4,
          saved_list_revenue: 15.to_m,
          saved_list_adds: 1,
          saved_list_deletes: 0
        )

        Metrics::ProductByDay.inc(
          key: { product_id: 'foo' },
          at: Time.zone.local(2018, 10, 29),
          saved_list_units_sold: 6,
          saved_list_revenue: 27.to_m,
          saved_list_adds: 1,
          saved_list_deletes: 1
        )

        Metrics::ProductByDay.inc(
          key: { product_id: 'bar' },
          at: Time.zone.local(2018, 10, 27),
          saved_list_units_sold: 3,
          saved_list_revenue: 11.to_m,
          saved_list_adds: 2,
          saved_list_deletes: 2
        )

        Metrics::ProductByDay.inc(
          key: { product_id: 'bar' },
          at: Time.zone.local(2018, 10, 28),
          saved_list_units_sold: 5,
          saved_list_revenue: 15.to_m,
          saved_list_adds: 1,
          saved_list_deletes: 1
        )

        Metrics::ProductByDay.inc(
          key: { product_id: 'bar' },
          at: Time.zone.local(2018, 10, 29),
          saved_list_units_sold: 7,
          saved_list_revenue: 27.to_m,
          saved_list_adds: 0,
          saved_list_deletes: 1
        )
      end

      def time_travel
        travel_to Time.zone.local(2018, 10, 30)
      end

      def test_grouping_and_summing
        report = SaveForLaterProducts.new
        assert_equal(2, report.results.length)

        foo = report.results.detect { |r| r['_id'] == 'foo' }
        assert_equal(12, foo['units_sold'])
        assert_equal(52, foo['revenue'])
        assert_equal(4, foo['adds'])
        assert_equal(2, foo['deletes'])

        bar = report.results.detect { |r| r['_id'] == 'bar' }
        assert_equal(15, bar['units_sold'])
        assert_equal(53, bar['revenue'])
        assert_equal(3, bar['adds'])
        assert_equal(4, bar['deletes'])
      end

      def test_date_ranges
        report = SaveForLaterProducts.new
        foo = report.results.detect { |r| r['_id'] == 'foo' }
        assert_equal(4, foo['adds'])

        report = SaveForLaterProducts.new(starts_at: '2018-10-28', ends_at: '2018-10-28')
        foo = report.results.detect { |r| r['_id'] == 'foo' }
        assert_equal(1, foo['adds'])

        report = SaveForLaterProducts.new(starts_at: '2018-10-28', ends_at: '2018-10-29')
        foo = report.results.detect { |r| r['_id'] == 'foo' }
        assert_equal(2, foo['adds'])

        report = SaveForLaterProducts.new(starts_at: '2018-10-28')
        foo = report.results.detect { |r| r['_id'] == 'foo' }
        assert_equal(2, foo['adds'])

        report = SaveForLaterProducts.new(ends_at: '2018-10-28')
        foo = report.results.detect { |r| r['_id'] == 'foo' }
        assert_equal(3, foo['adds'])
      end

      def test_sorting
        report = SaveForLaterProducts.new(sort_by: 'adds', sort_direction: 'asc')
        assert_equal('bar', report.results.first['_id'])

        report = SaveForLaterProducts.new(sort_by: 'adds', sort_direction: 'desc')
        assert_equal('foo', report.results.first['_id'])

        report = SaveForLaterProducts.new(sort_by: 'units_sold', sort_direction: 'asc')
        assert_equal('foo', report.results.first['_id'])

        report = SaveForLaterProducts.new(sort_by: 'units_sold', sort_direction: 'desc')
        assert_equal('bar', report.results.first['_id'])
      end
    end
  end
end
