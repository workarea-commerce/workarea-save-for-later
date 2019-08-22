module Workarea
  module Storefront
    module SavedListsHelper
      def save_for_later_analytics_data(item)
        {
          event: 'savedForLater',
          domEvent: 'submit',
          payload: order_item_analytics_data(item)
        }
      end
    end
  end
end
