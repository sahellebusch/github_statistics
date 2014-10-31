#!/usr/bin/env ruby
require_relative 'git_stat_module'

class GitStatTool
  extend GitStatsModule

  def initialize
    username = GitStatTool.get_username
    password = GitStatTool.get_user_password
    @user    = GitStatTool.authorize_get_user(username, password)
    go
  end

  def go
    options = GitStatTool.get_repos(@user)
    ap options
  end
end

GitStatTool.new
