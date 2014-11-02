#!/usr/bin/env ruby

class GitStatTool
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
    print_repos
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

  # Prints a welcome statement along with a list of the user's 
  # repositories, date created and last pushed.
  def print_repos
    say("<%= color('Welcome to the GitHub repository statistics tool.', :headline) %>")
    say("<%= color('                  Your Repositories, total: #{@Repos.size}\n', :bold) %>")
    say("<%= color('  name                    date dreated             last pushed       \n', :underscore) %>")
    @Repos.each { |repo|
      spaces = 24 - repo[:name].length
      print " #{repo[:name]}"
      printf( "%-#{spaces}s", ''   )
      spaces = 24 - repo[:created_at].strftime("%d %B, %Y").length
      print "#{repo[:created_at].strftime("%d %B, %Y")}"
      printf( "%-#{spaces}s", ''   )
      puts "#{repo[:last_pushed].strftime("%d %B, %Y")}"
    }
  end

  # Get a list of user repositories, sorted buy
  # the date & time of creation
  #
  # == Parameters:
  #  user::
  #    user Sawyer::Resource object
  # == Returns:
  # return an array of the user's repositories
  def get_repos(user)
    repos   = Array.new
    response = user.repositories
    begin
      response.each {  |repo|
        repo_hash = {:name => repo["name"],
                     :created_at => repo["created_at"],
                     :last_pushed => repo["pushed_at"] }
        repos.push(repo_hash)
      }
      return repos.sort_by { |repo|  repo[:created_at] }
    rescue Exception => e
      abort GET_REPO_FAILURE_MSG
    end
  end

end
