module GitStatsModule
	require 'english'
	require 'highline/import'
	require 'octokit'

	LOGIN_FAILURE_MSG = "Authentication failed."

	def get_username
		# TODO find out real username requirements
		username = ask("Github login: ") { |un| un.validate = /^[\w]{4,20}$/ }
	end

	def get_user_password
		#TODO find out real password requirements
		password = ask("Enter your password:  ") { |pw|
			pw.echo = false
			pw.validate = /^[\w\W]{3,20}$/
		}
	end

	def authorize_create_user(username, password)
		client = Octokit::Client.new(:login => username, :password => password)
		begin
			client.user
		rescue Exception => e
			abort LOGIN_FAILURE_MSG
		end
	end
end