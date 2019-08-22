module Workarea
  module Storefront
    module SavedListsHelper
      def add_to_saved_list_analytics_data(product)
        {
          event: 'addToSavedList',
          domEvent: 'submit',
          payload: product_analytics_data(product)
        }
      end

      def remove_from_saved_list_analytics_data(product)
        {
          event: 'removeFromSavedList',
          domEvent: 'submit',
          payload: product_analytics_data(product)
        }
      end
    end
  end
end
