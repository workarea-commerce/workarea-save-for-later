require 'workarea/testing/factories'

module Workarea
  module Factories
    module SavedList
      Factories.add(SavedList)

      def create_saved_list(attributes = {})
        Workarea::SavedList.create!(attributes)
      end
    end
  end
end
