module Workarea
  module Storefront
    module CurrentSavedList
      extend ActiveSupport::Concern

      included do
        helper_method :current_saved_list, :current_saved_list?
      end

      def current_saved_list?
        cookies[:saved_list_id].present? || current_user.present?
      end

      def current_saved_list
        @current_saved_list ||= SavedListViewModel.wrap(
          if current_user.present?
            SavedList.find_or_create_by(user_id: current_user.id)
          elsif cookies[:saved_list_id].present?
            SavedList.find_or_create_by(id: cookies[:saved_list_id])
          else
            SavedList.create.tap { |l| self.current_saved_list = l }
          end
        )
      end

      def current_saved_list=(list)
        cookies.permanent[:saved_list_id] = list&.id
        @current_saved_list = nil
      end

      def login(user)
        copy_saved_list { super }
      end

      def copy_saved_list
        saved_list = current_saved_list if current_saved_list?

        yield

        if saved_list.present?
          self.current_saved_list = nil

          saved_list.items.each do |item|
            current_saved_list.add_item(
              item.attributes.slice('product_id', 'sku', 'quantity', 'customizations')
            )
          end

          saved_list.destroy
        end
      end
    end
  end
end
