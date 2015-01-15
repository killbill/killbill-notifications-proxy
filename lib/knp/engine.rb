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

    initializer 'knp.load_app_root' do |app|
      config_file = File.join(app.root, 'config', 'knp.yml') unless app.root.nil?
      ::Knp::KNP_CONFIG = Configuration.new(config_file)
    end
  end
end
