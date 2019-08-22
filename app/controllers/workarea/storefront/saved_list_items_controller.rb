module Workarea
  module Storefront
    class SavedListItemsController < ApplicationController
      before_action :validate_customizations, only: :create

      def create
        if current_saved_list.add_item(saved_list_params.to_h)
          if params[:cart_item_id].present?
            current_order.remove_item(params[:cart_item_id])
          end

          flash[:success] =
            t('workarea.storefront.saved_lists.flash_messages.created')
        else
          flash[:error] =
            t('workarea.storefront.saved_lists.flash_messages.error')
        end

        redirect_to cart_path
      end

      def destroy
        current_saved_list.remove_item(params[:id])

        flash[:success] =
          t('workarea.storefront.saved_lists.flash_messages.destroyed')
        redirect_to cart_path
      end

      private

      def validate_customizations
        return unless customizations.present? && !customizations.valid?

        flash[:error] = t('workarea.storefront.saved_lists.flash_messages.error')
        redirect_to cart_path
        return false
      end

      def saved_list_params
        params.permit(:product_id, :sku, :quantity)
              .merge(customizations: customizations.try(:to_h) || {})
      end

      def customizations
        return unless params[:customizations].present?

        @customizations ||= Catalog::Customizations.find(
          params[:product_id],
          JSON.parse(params[:customizations])
        )
      end
    end
  end
end
