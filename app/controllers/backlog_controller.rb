require 'kramdown'
class BacklogController < ApplicationController
  include ApplicationHelper
  include BacklogHelper

  def index
    project = Project.where(:name => params[:name], :scope => params[:scope]).first
    can_access? project
    session[:selected_project] = project.id
    @user_story = UserStory.new
    github = Github.new :oauth_token => current_user.token
    selected_project.repos.each { |repo|
      update_issues github, repo, selected_project
    }
  end

  def create
    redirect_to root if !selected_project
    @user_story = UserStory.new(params[:user_story])
    @user_story.user_story_status = selected_project.user_story_statuses.where(:default => true).first
    @user_story.project = selected_project
    @user_story.identifier = selected_project.user_stories.maximum(:identifier).to_i + 1
    @user_story.position = selected_project.user_stories.maximum(:position).to_i + 1
    @user_story.user = current_user
    @user_story.next_sprint = false
    @user_story.current_sprint = false
    @user_story.historized = false
    (redirect_to( :controller => 'backlog',:scope => selected_project.scope, :name => selected_project.name) and return)  if @user_story.save
    render :action => 'index'
  end

  def reorder
    params[:item].each_with_index { |id, index|
      UserStory.update_all(['position=?', index+1], ['id=?', id])
    }
    render nil
  end

  def show
    project = Project.where(:name => params[:name], :scope => params[:scope]).first
    can_access? project
    session[:selected_project] = project.id
    @user_story = UserStory.where(:identifier => params[:identifier], :project_id => project).first
    github = Github.new :oauth_token => current_user.token
    project.repos.each { |repo|
      update_issues github, repo, selected_project
    }
  end

  def ready
    project = Project.where(:name => params[:name], :scope => params[:scope]).first
    can_access? project
    session[:selected_project] = project.id
    @user_story = UserStory.where(:identifier => params[:identifier], :project_id => project).first
    (redirect_to ({:action => 'index'}) and return) if @user_story.user_story_status.name != "Draft"
    @user_story.user_story_status = UserStoryStatus.where(:project_id => project, :name => 'Ready to be implemented').first
    (redirect_to (:back) and return) if @user_story.save
  end

  def draft
    project = Project.where(:name => params[:name], :scope => params[:scope]).first
    can_access? project
    session[:selected_project] = project.id
    @user_story = UserStory.where(:identifier => params[:identifier], :project_id => project).first
    (redirect_to ({:action => 'index'}) and return) if @user_story.user_story_status.name != "Ready to be implemented"
    @user_story.user_story_status = UserStoryStatus.where(:project_id => project, :name => 'Draft').first
    (redirect_to (:back) and return) if @user_story.save
  end
  def accept
    project = Project.where(:name => params[:name], :scope => params[:scope]).first
    can_access? project
    session[:selected_project] = project.id
    @user_story = UserStory.where(:identifier => params[:identifier], :project_id => project).first
    (redirect_to ({:action => 'index'}) and return) if @user_story.user_story_status.name != "In progress"
    @user_story.user_story_status = UserStoryStatus.where(:project_id => project, :name => 'Accepted').first
    (redirect_to (:back) and return) if @user_story.save
  end
  def reject
    project = Project.where(:name => params[:name], :scope => params[:scope]).first
    can_access? project
    session[:selected_project] = project.id
    @user_story = UserStory.where(:identifier => params[:identifier], :project_id => project).first
    (redirect_to ({:action => 'index'}) and return) if @user_story.user_story_status.name != "In progress"
    @user_story.user_story_status = UserStoryStatus.where(:project_id => project, :name => 'Rejected').first
    (redirect_to (:back) and return) if @user_story.save
  end

  def progress
    project = Project.where(:name => params[:name], :scope => params[:scope]).first
    can_access? project
    session[:selected_project] = project.id
    @user_story = UserStory.where(:identifier => params[:identifier], :project_id => project).first
    (redirect_to ({:action => 'index'}) and return) if @user_story.user_story_status.name != "Accepted" && @user_story.user_story_status.name != "Rejected"
    @user_story.user_story_status = UserStoryStatus.where(:project_id => project, :name => 'In progress').first
    (redirect_to (:back) and return) if @user_story.save
  end

  def delete
    project = Project.where(:name => params[:name], :scope => params[:scope]).first
    can_access? project
    session[:selected_project] = project.id
    @user_story = UserStory.where(:identifier => params[:identifier], :project_id => project).first
    (redirect_to ({:action => 'index'}) and return) if @user_story.delete
  end

  def edit
    project = Project.where(:name => params[:name], :scope => params[:scope]).first
    can_access? project
    session[:selected_project] = project.id
    @user_story = UserStory.where(:identifier => params[:identifier], :project_id => project).first
     (redirect_to ({:action => 'index'}) and return) if @user_story.historized
    if !params[:user_story].nil?
      params[:user_story].each do |key,value|
        @user_story[key] = value if @user_story.attribute_names.include?(key.to_s)
      end
      (redirect_to( :action => 'show',:scope => selected_project.scope, :name => selected_project.name, :identifier => @user_story.identifier) and return) if @user_story.save
    end
  end
end
