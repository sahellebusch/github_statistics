#!/usr/bin/env ruby

class GitStatToolRepo
	require 'english'
	require 'highline/import'
	require 'octokit'
	require 'awesome_print'
	require 'json'


	# Get a list of user repositories, sorted buy
	# the date & time of creation
	#
	# == Parameters:
	#  user::
	#    user Sawyer::Resource object
	#
	# == Returns:
	# return an array of the user's repositories
	def get_repos(user)
		repos   = Array.new
		response = user.repositories(nil, options = {'sort' => 'created'})
		begin
			response.each {  |repo|
				repo_hash = {:name => repo["name"],
							 :created_at => repo["created_at"],
							 :last_pushed => repo["pushed_at"] }
				repos << repo_hash
			}
			return repos
		rescue Exception => e
			abort GET_REPO_FAILURE_MSG
		end
	end

	# Prints a welcome statement along with a list of the user's
	# repositories, date created and last pushed.
	def print_repos(repos)
		say("<%= color('Welcome to the GitHub repository statistics tool.', :headline) %>")
		say("<%= color('                  Your Repositories, total: #{repos.size}\n', :bold) %>")
		say("<%= color('  name                    date dreated             last pushed       \n', :underscore) %>")
		repos.each { |repo|
			spaces = 24 - repo[:name].length
			print " #{repo[:name]}"
			printf( "%-#{spaces}s", ''   )
			spaces = 24 - repo[:created_at].strftime("%d %B, %Y").length
			print "#{repo[:created_at].strftime("%d %B, %Y")}"
			printf( "%-#{spaces}s", ''   )
			puts "#{repo[:last_pushed].strftime("%d %B, %Y")}"
		}
	end

	def select_repo(repos)
		continue = true
		while continue
			choice = ask("Input a repo name or all => ") { |name| name.validate = /^[\w-]*$/m }
			if choice == 'all'
				continue = false
				choice = repos
			else
				repos.each { |repo|
					if choice == repo[:name]
						continue = false
						choice = repo
					end
				}
			end
			if continue
				say("That is not a name of a repo you own.")
			end
		end
		return choice
	end


end
