require 'test_helper'

module Workarea
  class SavedListTest < TestCase
    def test_add_item
      product = create_product

      list = SavedList.new

      list.add_item(product_id: 'PROD1', sku: 'SKU1')
      assert_equal(1, list.items.count)

      item = list.items.first
      assert_equal('PROD1', item.product_id)
      assert_equal('SKU1', item.sku)
      assert_equal(1, item.quantity)

      list.add_item(
        product_id: 'PROD1',
        sku: 'SKU2',
        quantity: 3,
        customizations: { 'foo' => 'bar' }
      )
      assert_equal(2, list.items.count)

      item = list.items.where(sku: 'SKU2').first
      assert_equal('PROD1', item.product_id)
      assert_equal('SKU2', item.sku)
      assert_equal(3, item.quantity)
      assert_equal({ 'foo' => 'bar' }, item.customizations)

      list.add_item(product_id: 'PROD1', sku: 'SKU1', quantity: 4)

      item = list.items.where(sku: 'SKU1').first
      assert_equal('PROD1', item.product_id)
      assert_equal('SKU1', item.sku)
      assert_equal(5, item.quantity)
    end
  end
end
