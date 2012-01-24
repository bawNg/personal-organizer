require 'bundler/setup'
Bundler.require
require 'active_support/core_ext'
require 'pp'

require_relative 'web_interface'

MongoMapper.database = "personal_organizer"

EM.run do
  Thin::Server.new('0.0.0.0', 8080) do
    use Rack::CommonLogger

    map '/' do
      run WebInterface.new
    end
  end.start
end