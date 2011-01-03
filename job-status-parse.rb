require 'rubygems'
require 'json'

a = JSON::parse(ARGF.read)
#p a 
p a["JobFlows"][0]["ExecutionStatusDetail"]["State"]
