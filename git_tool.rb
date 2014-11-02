#!/usr/bin/env ruby

require 'optparse'
require_relative 'lib/git_stat_tool_user'

def get_user
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
	if options[:username]
		username = options[:username]
	else
		username = @tool_user.get_username
	end
	if options[:password]
		password = options[:password]
	else
		password = @tool_user.get_user_password
	end
	user = @tool_user.init_user(username, password)
end

########### Tool Control ###########
@tool_user = GitStatToolUser.new
@tool_repo = GitStatToolRepo.new
@user      = get_user
@repos     = @tool_repo.get_repos(@user)
@tool_repo.print_repos(@repos)
@repos     = @tool_repo.select_repo(@repos)
