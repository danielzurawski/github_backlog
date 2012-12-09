class UserController < ApplicationController
  include ApplicationHelper
  autocomplete :user, :login
end
