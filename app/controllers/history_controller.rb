class HistoryController < ApplicationController
	include ApplicationHelper
  def index
  	project = Project.where(:name => params[:name], :scope => params[:scope]).first
    can_access? project
    session[:selected_project] = project.id
  end
end
