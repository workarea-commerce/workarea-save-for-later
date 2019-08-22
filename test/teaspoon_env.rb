require 'workarea/testing/teaspoon'

Teaspoon.configure do |config|
  config.root = Workarea::SaveForLater::Engine.root
  Workarea::Teaspoon.apply(config)
end
