require 'restclient'

# grab the command line arguements
@ttl = ARGV[0]
@proxy = ARGV[1].to_s

#assume we;re inside reith
unless ARGV[1] == '--no-proxy'
  RestClient.proxy = "http://www-cache.reith.bbc.co.uk/"
end

#set up SSL for RestClient
SSL = {
  :ssl_client_cert => OpenSSL::X509::Certificate.new(File.read("/Users/tarlij01/Documents/certs/Forge.pem")),
  :ssl_client_key => OpenSSL::PKey::RSA.new(File.read("/Users/tarlij01/Documents/certs/Forge.pem")),
}

#assign the URL, starting with int and  dry-run
@url = "https://api.int.bbc.co.uk/ldp-writer/datasets?dry-run=true"

# make the request, catch the error if it's not a 200
begin
  resource = RestClient::Resource.new(@url, SSL)
  @response = resource.put(File.read(@ttl), :content_type => 'application/x-turtle') 
rescue => e
  @response = e.response
end

# show the response code
puts "HTTP response code: #{@response.code}"

# show the response body
puts @response.body

# grab the nextUrl and assign it
puts "\n=== next URL ==="
nextUrl = @response.body.lines.grep(/nextUrl/)
@url = nextUrl[0].to_s.sub("nextUrl=","")
puts "value of @url now set to #{@url}"
puts "proceed to next step?"

