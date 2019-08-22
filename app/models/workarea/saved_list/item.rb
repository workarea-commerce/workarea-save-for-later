module Workarea
  class SavedList
    class Item
      include ApplicationDocument

      field :product_id, type: String
      field :sku, type: String
      field :quantity, type: Integer, default: 1
      field :customizations, type: Hash, default: {}

      embedded_in :saved_list, class_name: 'Workarea::SavedList'
    end
  end
end
