require 'bundler'
Bundler.setup
require 'iu_moip'
require 'simplecov'

Dir[ File.join(File.dirname(__FILE__), '**/support/*.rb' )].each { |file| require file }

SimpleCov.start do
  add_filter "/spec/"
end