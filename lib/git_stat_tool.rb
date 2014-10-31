#!/usr/bin/env ruby
require_relative 'git_stat_module'

class GitStatTool
	extend GitStatsModule

	def initialize
		username = GitStatTool.get_username
		password = GitStatTool.get_user_password
		@user 	 = GitStatTool.authorize_create_user(username, password)
		puts @user.class
	end
end

GitStatTool.new
