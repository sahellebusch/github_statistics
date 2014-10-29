#!/usr/bin/env ruby
require 'english'
require 'highline/import'
require 'octokit'

class GitStats

	@client

	def initialize 
		go
	end

	# runs the program in sequential order
	def go 
		create_github_client
	end

	# gets input form use to build Github user client to act on
	def create_github_client
		# print("Github username: ")
		# TODO find out real username requirements
		username = ask("Github login: ") { |un| un.validate = /^[a-z0-9_-]{3,20}$/ }
		password = ask("Enter your password:  ") { |pw|
			 pw.echo = false 
			 #TODO find out real password requirements
			 pw.validate = /^[a-z0-9_-]{3,18}$/
		}
		@client = Octokit::Client.new(:login => username, :password => password)
		puts @client.user
		if @client.user
			puts "success"
		else
			puts "failed to login"
		end
	end

end

GitStats.new