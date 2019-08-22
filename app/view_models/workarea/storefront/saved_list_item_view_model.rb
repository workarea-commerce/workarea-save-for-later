module Workarea
  module Storefront
    class SavedListItemViewModel < ApplicationViewModel
      delegate :name, :purchasable?, :sell_min_price, to: :product

      def product
        @product ||= ProductViewModel.wrap(
          Catalog::Product.find(product_id),
          options.merge(sku: sku, inventory: nil)
        )
      end

      def image
        product.primary_image
      end

      def variant
        product.model.variants.where(sku: sku).first
      end

      def inventory_status
        InventoryStatusViewModel.new(inventory).message
      end

      def details
        @details ||= Hash[
          variant.details.map do |k, v|
            [k.to_s.titleize, [v].flatten.join(', ')]
          end
        ]
      end

      def total_price
        sell_min_price * quantity
      end

      private

      def inventory
        @inventory ||=
          options[:inventory] || Inventory::Sku.find_or_create_by(id: sku)
      end
    end
  end
end
