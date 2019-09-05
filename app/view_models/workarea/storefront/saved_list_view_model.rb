module Workarea
  module Storefront
    class SavedListViewModel < ApplicationViewModel
      def items
        @items ||= model.items.map do |item|
          SavedListItemViewModel.wrap(
            item,
            options.merge(inventory: inventory.for_sku(item.sku))
          )
        end
      end

      def inventory
        @inventory ||= Inventory::Collection.new(model.items.map(&:sku))
      end
    end
  end
end
