require 'restclient'

# grab the cmd line args + set @url to int
@ttl = ARGV[0]
@proxy = ARGV[1].to_s
@url = "https://api.int.bbc.co.uk/ldp-writer/datasets?dry-run=true"

#set up SSL for RestClient
SSL = {
  :ssl_client_cert => OpenSSL::X509::Certificate.new(File.read("/Users/tarlij01/Documents/certs/Forge.pem")),
  :ssl_client_key => OpenSSL::PKey::RSA.new(File.read("/Users/tarlij01/Documents/certs/Forge.pem")),
}

#assume we're inside reith
def getProxy
  unless ARGV[1] == '--no-proxy'
    RestClient.proxy = "http://www-cache.reith.bbc.co.uk/"
  end
end

# make the PUT request, let RestClient catch the error if it's not a 200
def putData
  begin
    resource = RestClient::Resource.new(@url, SSL)
    @response = resource.put(File.read(@ttl), :content_type => 'application/x-turtle') 
  rescue => e
    @response = e.response
  end
end

# update the vale of @url from the response to the PUT
def getNextUrl
  @nextUrl = @response.body.lines.grep(/nextUrl/)
  @url = @nextUrl[0].to_s.sub("nextUrl=","")
end

#  talk to me
def feedBack
  puts "HTTP response code: #{@response.code}"
  puts @response.body
  puts "\n=== next URL ==="
  getNextUrl
  puts "value of @url now set to #{@url}"
end

def nextStep
  puts "proceed to next step? (y|n)"
  @answer = STDIN.gets.chomp
  if @answer == 'y'
    putData
    feedBack
    nextStep
  elsif @answer == 'n'
    puts "bye!"
  end
end

# call some methods
def ldpUpload
  getProxy
  putData
  feedBack
  nextStep
end

ldpUpload


