module Workarea
  class SavedList
    include ApplicationDocument

    field :user_id, type: String

    embeds_many :items, class_name: 'Workarea::SavedList::Item'

    index({ user_id: 1 })
    index(
      { updated_at: 1 },
      {
        expire_after_seconds: Workarea.config.saved_lists_expiration,
        partial_filter_expression: {
          user_id: { '$eq' => nil }
        }
      }
    )

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
