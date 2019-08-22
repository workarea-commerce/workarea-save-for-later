module Workarea
  class SavedList
    include ApplicationDocument

    # Will be either a object id for guests, or a user's id
    field :_id, type: String, default: -> { BSON::ObjectId.new.to_s }

    embeds_many :items, class_name: 'Workarea::SavedList::Item'

    def add_item(item_attributes = {})
      item_attributes = item_attributes.with_indifferent_access
      existing = items.where(item_attributes.slice(:sku, :customizations)).first

      if existing.present?
        existing.quantity = existing.quantity + item_attributes[:quantity].to_i
      else
        items.build(item_attributes)
      end

      save
    end

    def remove_item(id)
      items.find(id).destroy
    end
  end
end
