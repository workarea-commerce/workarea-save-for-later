module Workarea
  module SaveForLater
    class Engine < ::Rails::Engine
      include Workarea::Plugin
      isolate_namespace Workarea::SaveForLater

      config.to_prepare do
        Storefront::ApplicationController.include(Storefront::CurrentSavedList)
        Storefront::ApplicationController.send(:helper, Storefront::SavedListsHelper)
      end
    end
  end
end
