module GitStatsModule
  require 'english'
  require 'highline/import'
  require 'octokit'
  require 'awesome_print'
  require 'json'

  USER_AUTHENTICATION_ERROR    = "Authentication failed."
  GET_REPO_FAILURE_MSG = "An error occurred while trying to get repos. Gracefully exiting."

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

  # Calls user.user to validate users credentials
  # Params:
  # +username+:: user provided Github username
  # +password+:: user provided Github password
  def authorize_get_user(username, password)
    user = Octokit::Client.new(:login => username, :password => password)
    if (user.user)
      return user
    else
      abort USER_AUTHENTICATION_ERROR
    end
  end

  # Retrieves list of repository names
  # Params:
  # +user+:: the Github user
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
