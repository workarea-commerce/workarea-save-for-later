$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "workarea/save_for_later/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "workarea-save_for_later"
  s.version     = Workarea::SaveForLater::VERSION
  s.authors     = ["Matt Duffy"]
  s.email       = ["mduffy@weblinc.com"]
  s.homepage    = "https://github.com/workarea-commerce/workarea-save-for-later"
  s.summary     = "Workarea Commerce plugin for saving items from cart for later"
  s.description = "Workarea Commerce plugin for saving items from cart for later"

  s.files = `git ls-files`.split("\n")

  s.license = 'Business Software License'



s.add_dependency 'workarea', '~> 3.x'
end
