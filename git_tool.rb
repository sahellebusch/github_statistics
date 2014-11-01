#!/usr/bin/env ruby

require 'optparse'
require 'pp'
require_relative 'lib/git_stat_tool'

options = {}

optparse = OptionParser.new do|opts|
	opts.on( '-h', '--help', 'Display this screen' ) do
		puts opts
		exit
	end
	options[:username] = false
	opts.on( '-u', '--username USERNAME', "GitHub username" ) do|f|
		options[:username] = f
	end
	options[:password] = false
	opts.on( '-p', '--password PASSWORD', "GitHub password" ) do|f|
		options[:password] = f
	end
end

optparse.parse!
GitStatTool.new.go(options)
