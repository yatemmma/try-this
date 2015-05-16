require 'sinatra/base'

SITE_DOMAIN = 'https://try-this.herokuapp.com'

class TryThis < Sinatra::Application
  get '/' do
    @links = {
      :mobileconfig => "#{SITE_DOMAIN}/udid.mobileconfig",
      :manifest => "#{SITE_DOMAIN}/manifest.plist"
    }
    erb :index
  end

  get '/udid.mobileconfig' do
    @mobileconfig = {
      :url => "#{SITE_DOMAIN}/device_detection"
    }

    content_type 'text/xml'
    erb :udid_mobileconfig
  end

  post '/device_detection' do
    device_info = request.body.read

    keys = %w(UDID IMEI VERSION PRODUCT MEID SERIAL)
    detected_info = keys.map do |key|
      matched = Regexp.new('<key>'+key+'<\/key>\s*<string>(.*)<\/string>').match(device_info)
      [key, matched.to_a.last] unless matched.nil?
    end

    p Hash[*detected_info.flatten]

    redirect "/", 301
  end

  get '/manifest.plist' do
    @manifest = {
      :title => 'test app',
      :version => '0.1',
      :identifier => 'com.github.yatemmma.test',
      :url => "#{SITE_DOMAIN}/test.ipa"
    }

    content_type 'text/xml'
    erb :manifest_plist
  end

  get '/test.ipa' do
    send_file('test.ipa', {:type => 'application/octet-stream'})
  end
end