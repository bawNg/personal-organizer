require "sinatra/reloader"
require_relative 'lib/rack/flash'
require_relative 'helpers/sinatra'

class WebInterface < Sinatra::Base
  register Sinatra::Reloader
  register Sinatra::Async
  also_reload "helpers/*.rb"
  also_reload "models/*.rb"

  use Rack::Session::Cookie, :secret => 'p3rs0n410rg4n123r'
  use Rack::MethodOverride
  use Rack::Flash

  set :root, File.dirname(__FILE__)

  helpers WebHelpers

  mime_type :coffee, 'text/coffeescript'

  def self.async_connections
    @async_connections ||= []
  end

  get '/' do
    slim :index
  end

  aget '/ajax/updates' do
    content_type 'text/javascript'
    on_close do
      self.class.async_connections.delete self
    end
    self.class.async_connections << self
  end
end