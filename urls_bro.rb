require 'net/https'
require 'uri'

URL = /((([A-Za-z]{3,9}:(?:\/\/)?)(?:[\-;:&=\+\$,\w]+@)?[A-Za-z0-9\.\-]+|(?:www\.|[\-;:&=\+\$,\w]+@)[A-Za-z0-9\.\-]+)((?:\/[\+~%\/\.\w\-_]*)?\??(?:[\-\+=&;%@\.\w_]*)#?(?:[\.\!\/\\\w]*))?)/

SHORTENER = "https://url.corp.redhat.com/new?%s"

def web_request(uri)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(uri.request_uri)

  response = http.request(request)
  response.body
end

def shorten(url)
  web_request(URI.parse(SHORTENER % url))
end

def shorten_urls_in_message(message)
  urls = message.scan(URL).collect { |url| url[0] }
  Thread.new do
    urls.each do |url|
      puts shorten(url)
    end
  end unless urls.empty?
end
