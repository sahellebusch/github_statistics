#!/usr/bin/env ruby

class GitStatTool
  require 'english'
  require 'highline/import'
  require 'octokit'
  require 'awesome_print'
  require 'json'

  USER_AUTHENTICATION_ERROR    = "Authentication failed."
  GET_REPO_FAILURE_MSG = "An error occurred while trying to get repos. Exiting."
  
  def initialize
    #go
  end

  def go
    username = get_username
    password = get_user_password
    @User = init_user(username, password)
    @Repos = get_repos(@User)
    print_welcome
  end

  # Prompts for and retrieves Github username
  def get_username
    # TODO find out real username requirements
    username = ask("Github login: ") { |un| un.validate = /^[\w]{4,20}$/ }
  end

  # Prompts for and retrieves Github password
  def get_user_password
    #TODO find out real password requirements
    password = ask("Enter your password:  ") { |pw|
      pw.echo = false
      pw.validate = /^[\w\W]{3,20}$/
    }
  end

  # Creates and authorizes the GitHub user
  # Params:
  # +username+:: user's GitHub username
  # +password+:: user's GitHub password
  def init_user(username, password)
    new_user = Octokit::Client.new(:login => username, :password => password)
    begin
      new_user.user
    rescue Exception => e
      abort USER_AUTHENTICATION_ERROR      
    end
    return new_user
  end

  def print_welcome
    puts "You currently have #{@Repos.size} repositories."
  end

  def get_repos(user)
    begin
      repos = Array.new
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
