LDP-upload
==========
ruby script to upload RDF/TTL data to the BBC's Linked Data Platform

doing this through Postman was getting a bit repetitive, ruby + rest-client to the rescue

needs the rest-client gem and a valid BBC SSL cerificate that's been added to the Linked Data Platform's whitelist.

run from the command line:

ruby LDP-upload.rb [--int|--test|--stage|--live] [--no-proxy]


