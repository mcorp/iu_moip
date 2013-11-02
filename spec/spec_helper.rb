require 'bundler'
Bundler.setup
require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

require 'iu_moip'

Dir[ File.join(File.dirname(__FILE__), '**/support/*.rb' )].each { |file| require file }
