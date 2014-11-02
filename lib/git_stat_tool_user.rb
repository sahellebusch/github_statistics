#!/usr/bin/env ruby
require_relative 'git_stat_tool_repo'

class GitStatToolUser
  require 'english'
  require 'highline/import'
  require 'octokit'
  require 'awesome_print'
  require 'json'

  USER_AUTH_ERROR      = "Authentication failed."
  GET_REPO_FAILURE_MSG = "An error occurred while trying to get repos. Exiting."

  ft = HighLine::ColorScheme.new do |cs|
    cs[:headline]        = [ :bold, :red ]
    cs[:horizontal_line] = [ :bold, :white ]
    cs[:blue]            = [ :blue ]
    cs[:even_row]        = [ :red ]
    cs[:odd_row]         = [ :green ]
    cs[:bold]            = [ :bold ]
  end
  HighLine.color_scheme = ft

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
  #
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
 
end
