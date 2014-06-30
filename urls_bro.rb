TITLE       = "urls_bro"
AUTHOR      = "komidore64"
VERSION     = "0.0.1"
LICENSE     = "GPL3"
DESCRIPTION = "a very simple url shortener using Red Hat's internal shortener"


URL_REGEX = /((([A-Za-z]{3,9}:(?:\/\/)?)(?:[\-;:&=\+\$,\w]+@)?[A-Za-z0-9\.\-]+|(?:www\.|[\-;:&=\+\$,\w]+@)[A-Za-z0-9\.\-]+)((?:\/[\+~%\/\.\w\-_]*)?\??(?:[\-\+=&;%@\.\w_]*)#?(?:[\.\!\/\\\w]*))?)/

SHORTENER = "https://url.corp.redhat.com/new?%s"


require 'net/https'
require 'uri'

def urls_bro(data, buffer, date, tags, visible, highlight, nick, message)
  urls = message.scan(URL_REGEX).collect { |url| url[0] }

  Thread.new do

    # this is for debug output
    #%w(data buffer date tags visible highlight nick message).each do |name|
    #  v = eval(name)
    #  Weechat.print("", "urls_bro \t#{name}: #{v.inspect}")
    #end

    urls.each do |url|
      uri = URI.parse(SHORTENER % url)

      http = Net::HTTP.new(uri.host, uri.port)

      # ssl shenanigans
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      # not sure if this works?
      http.read_timeout = 10 #seconds

      request = Net::HTTP::Get.new(uri.request_uri)

      begin
      response = http.request(request)
      Weechat.print(buffer, "==> #{response.body}")
      rescue
        err_url = url.slice(0, 20)
        err_url[17..19] = "..." if url.length > 20
        Weechat.print(buffer, "==> error retrieving url for #{err_url}")
      end
    end

  end unless urls.empty?

  return Weechat::WEECHAT_RC_OK
end

def weechat_init
  Weechat.register(TITLE, AUTHOR, VERSION, LICENSE, DESCRIPTION, "", "")

  Weechat.hook_print("", "irc_privmsg", "", 1, "urls_bro", "")

  return Weechat::WEECHAT_RC_OK
end
