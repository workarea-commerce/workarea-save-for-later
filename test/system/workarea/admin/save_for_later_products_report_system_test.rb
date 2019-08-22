require 'test_helper'

module Workarea
  module Admin
    class SaveForLaterProductsReportSystemTest < Workarea::SystemTest
      include Admin::IntegrationTest

      def test_saved_list_products_report
        create_product(id: 'foo', name: 'Foo')

        Metrics::ProductByDay.inc(
          key: { product_id: 'foo' },
          saved_list_adds: 1,
          saved_list_units_sold: 5
        )
        Metrics::ProductByDay.inc(
          key: { product_id: 'bar' },
          saved_list_adds: 4,
          saved_list_units_sold: 3
        )

        visit admin.save_for_later_products_report_path
        assert(page.has_content?('Foo'))
        assert(page.has_content?('bar'))
        assert(page.has_content?('1'))
        assert(page.has_content?('5'))
        assert(page.has_content?('4'))
        assert(page.has_content?('3'))

        click_link t('workarea.admin.fields.adds')
        assert(page.has_content?("#{t('workarea.admin.fields.adds')} ↓"))
        assert(page.has_ordered_text?('bar', 'Foo'))

        click_link t('workarea.admin.fields.units_sold')
        assert(page.has_content?("#{t('workarea.admin.fields.units_sold')} ↓"))
        assert(page.has_ordered_text?('Foo', 'bar'))

        click_link t('workarea.admin.fields.units_sold')
        assert(page.has_content?("#{t('workarea.admin.fields.units_sold')} ↑"))
        assert(page.has_ordered_text?('bar', 'Foo'))
      end
    end
  end
end
