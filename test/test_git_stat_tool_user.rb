#!/usr/bin/env ruby

require_relative '../lib/git_stat_tool_user'
require 'minitest/autorun'
require 'octokit'
require 'json'

class TestGitStatToolUser < Minitest::Test

    TEST_USER_PWD_FAIL = 'fail'
    USER_AUTH_ERROR    = "Authentication failed."

    def setup
        jsonfile     = File.read('test/test_credentials.json')
        @CREDENTIALS = JSON.parse(jsonfile)
        @tool        = GitStatToolUser.new
        @mock_user   = Octokit::Client.new(:login    => @CREDENTIALS["username"],
                                           :password => @CREDENTIALS["password"])
    end

    def test_init_user
        test_user = @tool::init_user(@CREDENTIALS["username"], @CREDENTIALS["password"])
        assert_equal @mock_user.class, test_user.class
    end


    def test_init_user_fail
        test_user = @tool::init_user(@CREDENTIALS["username"], @CREDENTIALS["password"])
        begin test_user.class
        rescue Exception => e
            assert_equal USER_AUTH_ERROR, e
        end
    end

end
