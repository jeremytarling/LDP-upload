LDP-upload
==========
a lazy man's ruby script to upload RDF/TTL data to the BBC's Linked Data Platform

doing this through Postman was getting a bit repetitive, ruby + rest-client to the rescue

needs the rest-client gem and a valid BBC SSL cerificate that's been added to the Linked Data Platform's whitelist.

run from the command line:

ruby LDP-upload.rb (myFile.ttl) [--no-proxy]

TODO:

* tidy up the ending so it bails if @url is null
* add the ability to specify the environment (int|test|stage|live) as an ARGV
 
