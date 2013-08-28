require 'rubygems' unless defined? ::Gem
require File.dirname( __FILE__ ) + '/app.rb'

if __FILE__ == $0
  require 'rack/handler/webrick'
  Rack::Handler::WEBrick.run MyApp.new, :Port => 9292
end

run MyApp
