#!/usr/bin/env ruby

require_relative '../lib/git_stat_tool_repo'
require_relative '../lib/git_stat_tool_user'
require 'minitest/autorun'
require 'octokit'
require 'json'

class TestGitStatToolRepo < Minitest::Test

	TEST_USER_PWD_FAIL = 'fail'
	USER_AUTH_ERROR    = "Authentication failed."

	def setup
		jsonfile     = File.read('test/test_credentials.json')
		@CREDENTIALS = JSON.parse(jsonfile)
		@user_tool   = GitStatToolUser.new
		@repo_tool   = GitStatToolRepo.new
		@mock_user   = Octokit::Client.new(:login    => @CREDENTIALS["username"],
										 :password => @CREDENTIALS["password"])
	end

	def test_get_repositories
		test_user      = @user_tool.init_user(@CREDENTIALS["username"], @CREDENTIALS["password"])
		test_repos     = @repo_tool.get_repos(test_user)
		# return an array of hashes, get just the names
		expected_repos = Array.new
		@mock_user.repositories(nil, options = {'sort' => 'created'}).each {  |repo|
			repo_hash = {:name => repo["name"],
						 :created_at => repo["created_at"],
						 :last_pushed => repo["pushed_at"] }
			expected_repos << repo_hash
		}
		assert_equal expected_repos, test_repos
	end

end
