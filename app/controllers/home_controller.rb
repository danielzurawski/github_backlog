class HomeController < ApplicationController
  include ApplicationHelper

  def index
  	if user_signed_in?
  		#github = Github.new :oauth_token => current_user.token
  		#@issues = github.issues.list :state => 'closed', :filter => 'all'
  	end
  end
end
