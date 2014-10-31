require 'minitest/autorun'
require 'minitest/unit'


MiniTest::Unit.autorun

class PrepareGitStatTool
  class Unit < MiniTest::Unit

    def before_suites
      # code to run before the first test
      p "Before everything"
      jsonfile = File.read('test_credentials.json')
        @CREDENTIALS = JSON.parse(jsonfile)
        @tool = Object.new
        @tool.extend(GitStatsModule)
        @mock_user = Octokit::Client.new(:login    => @CREDENTIALS["username"], 
                                         :password => @CREDENTIALS["password"])
        @mock_user = @mock_user.user
    end

    def after_suites
      # code to run after the last test
      p "After everything"
    end

    def _run_suites(suites, type)
      begin
        before_suites
        super(suites, type)
      ensure
        after_suites
      end
    end

    def _run_suite(suite, type)
      begin
        suite.before_suite if suite.respond_to?(:before_suite)
        super(suite, type)
      ensure
        suite.after_suite if suite.respond_to?(:after_suite)
      end
    end

  end
end

MiniTest::Unit._run_suite PrepareGitStatTool::Unit.new

class TestGitStatTool < MiniTest::Unit::TestCase

  def self.before_suite
    p "hi"
  end

  def self.after_suite
    p "bye"
  end

  def setup
    puts "this is the setup"
  end

  def test_authorize_create_user_pass
        test_user = @tool.authorize_create_user(@CREDENTIALS["username"], @CREDENTIALS["password"])
        test_user.user
        assert_equal(@mock_user.type, @tool.authorize_create_user(@CREDENTIALS["username"], 
                                                                  @CREDENTIALS["password"]).type)
    end


end