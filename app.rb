require 'sinatra/base'
 
class Application < Sinatra::Base

  get '/' do
    'hello try-this!'
  end
  
end