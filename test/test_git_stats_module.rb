#!/usr/bin/env ruby
require 'minitest/autorun'
require 'octokit'
require 'json'
require_relative '../lib/git_stat_module'

class TestGitStatsModule < MiniTest::Unit::TestCase

    TEST_USER_PWD_FAIL  = 'fail'

    def setup
        jsonfile = File.read('test_credentials.json')
        @CREDENTIALS = JSON.parse(jsonfile)
        @tool = Object.new
        @tool.extend(GitStatsModule)
        @mock_user = Octokit::Client.new(:login    => @CREDENTIALS["username"],
                                         :password => @CREDENTIALS["password"])
    end


    def test_authorize_create_user_pass
        test_user = @tool.authorize_get_user(@CREDENTIALS["username"], @CREDENTIALS["password"])
        test_user.user
        @mock_user = @mock_user.user
        assert_equal(@mock_user.type, @tool.authorize_get_user(@CREDENTIALS["username"],
                                                                  @CREDENTIALS["password"]).type)
    end

end
