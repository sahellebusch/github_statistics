#!/usr/bin/env ruby

class GitStatTool
  require 'english'
  require 'highline/import'
  require 'octokit'
  require 'awesome_print'
  require 'json'

  USER_AUTH_ERROR      = "Authentication failed."
  GET_REPO_FAILURE_MSG = "An error occurred while trying to get repos. Exiting."

  def go(options)
    if options[:username]
      username = options[:username]
    else
      username = get_username
    end
    if options[:password]
      password = options[:password]
    else
      password = get_user_password
    end
    @User  = init_user(username, password)
    @Repos = get_repos(@User)
    print_welcome
  end

  def get_username
    # TODO find out real username requirements
    username = ask("Github login: ") { |un| un.validate = /^[\w]{4,20}$/ }
  end

  def get_user_password
    #TODO find out real password requirements
    password      = ask("Enter your password:  ") { |pw|
      pw.echo     = false
      pw.validate = /^[\w\W]{3,20}$/
    }
  end

  # Creates and authorizes the GitHub user
  #
  # == Parameters:
  # username::
  #   user provided GitHub username
  # password::
  #   user provided GitHub password
  # == Returns:
  #  returns a Sawyer::Resource object
  def init_user(username, password)
    new_user = Octokit::Client.new(:login => username, :password => password)
    begin
      new_user.user
    rescue Exception => e
      abort USER_AUTH_ERROR
    end
    return new_user
  end

  def print_welcome
    puts "Welcome to the GitHub repository statistics tool. \nYou currently have #{@Repos.size} repositories."
  end

  # Get a list of user repositories
  #
  # == Parameters:
  #  user::
  #    user Sawyer::Resource object
  # == Returns:
  # return an array of the user's repositories
  def get_repos(user)
    begin
      repos    = Array.new
      response = user.repositories
      # return an array of hashes, get just the names
      response.each { |repo|
        repos.push(repo["name"])
      }
      return repos
    rescue Exception => e
      abort GET_REPO_FAILURE_MSG
    end
  end

end

GitStatTool.new
