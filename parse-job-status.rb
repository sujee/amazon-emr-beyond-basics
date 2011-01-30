require 'rubygems'
require 'json'

# takes input of a EMR job status on stdin and parses the job state
# usage : elastic-mapreduce  --describe  JOBID | ruby parse-job-status.rb

a = JSON::parse(ARGF.read)
#p a 
puts a["JobFlows"][0]["ExecutionStatusDetail"]["State"]
