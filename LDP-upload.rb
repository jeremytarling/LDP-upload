require 'restclient'
require 'json'

# grab the command line arguements
@ttl = ARGV[0]
@env = ARGV[1].to_s
@proxy = ARGV[2].to_s

# choose an environment form command line args
if @env == '--int'
  HOST = 'https://api.int.bbc.co.uk/'
elsif @env  == '--test'
  HOST = 'https://api.test.bbc.co.uk/'
elsif @env  ==  '--stage'
  HOST = 'https://api.stage.bbc.co.uk/'
elsif @env  ==  '--live'
  HOST = 'https://api.live.bbc.co.uk/'
elsif @env == '--localhost'
  HOST = 'http://localhost:8080/'
else puts "usage: must specify environment: --int|--test|--stage|--live|--local"
end

#assume we;re inside reith
unless ARGV[2] == '--no-proxy'
  RestClient.proxy = "http://www-cache.reith.bbc.co.uk/"
end
SSL = {
  :ssl_client_cert => OpenSSL::X509::Certificate.new(File.read("/Users/tarlij01/Documents/certs/Forge.pem")),
  :ssl_client_key => OpenSSL::PKey::RSA.new(File.read("/Users/tarlij01/Documents/certs/Forge.pem")),
}

#specify the path and params
PATH = 'ldp-writer/datasets'
PARAMS = '?dry-run=true'

#build the URL
@url = HOST + PATH + PARAMS

#check what we're asking for
puts "PUTing to #{@url}\n"

# make the request, catch the error if it's not a 200
begin
  resource = RestClient::Resource.new(@url, SSL)
  @response = resource.put(File.read(@ttl), :content_type => 'application/x-turtle') 
rescue => e
  @response = e.response
end

# show the response code
puts "=== response code ==="
puts @response.code

# show the response headers
#@response_headers = JSON.parse @response.headers
puts "=== response headers ==="
puts "date: #{@response.headers[:date]}"
puts "content type: #{@response.headers[:content_type]}"
puts "content legth: #{@response.headers[:content_length]}"

# show the response body
puts "=== response body ==="
puts @response.body.gsub(/<\/?[^>]*>/, '').gsub(/\n\n+/, "\n").gsub(/^\n|\n$/, '')


