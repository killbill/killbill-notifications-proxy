# Dependencies
#
# Sigh. Rails autoloads the gems specified in the Gemfile and nothing else.
# We need to explicitly require all of our dependencies listed in knp.gemspec
#
# See also https://github.com/carlhuda/bundler/issues/49
require 'killbill_client'

module Knp
  class Engine < ::Rails::Engine
    isolate_namespace Knp
  end
end
