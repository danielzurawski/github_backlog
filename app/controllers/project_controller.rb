require 'kramdown'
class ProjectController < ApplicationController
  include ApplicationHelper
  include ProjectHelper
  autocomplete :user, :login

  # Public : Method called to create a project after /new
  #
  def create
    @project = Project.new(params[:project])
    flash.clear
    @project.bind_on_create current_user
    if Project.where("UPPER(name) = ? AND UPPER(scope) = ?", @project.name.upcase, @project.scope.upcase).count > 0
      flash[:error] = "Project already exists"
      render :action =>  'new'
      return
    end
    (render :action =>  'new' and return) unless @project.save
    generate_default_data @project
    current_user.grant_access @project
    session[:selected_project] = @project.id
    github = Github.new :oauth_token => current_user.token
    @repos = github.repos.list
    @github = Repo.new
  end

  # Public : Action called to delete a project
  # - id : ID of the project to delete
  #
  #
  def delete
    @project = Project.where(:scope => params[:scope], :name => params[:name]).first
    can_access? @project
    session[:selected_project] = nil if @project.id == session[:selected_project].to_i
    flash[:notice] = "Project was successfuly deleted!"
    redirect_to ({:action => 'list'}) if @project.delete
    flash[:notice] = "Something went wrong"
  end

  #
  #
  #
  def linked
    @github = Repo.new(params[:repo])
    @github.owner = @github.repo.split('/')[0]
    @github.repo = @github.repo.split('/')[1]
    @project = Project.find(session[:selected_project])
    can_access? @project
    @github.project = @project
    github = Github.new :oauth_token => current_user.token
    @repos = github.repos.list
    render :action => 'create' unless @github.save
  end

  #
  #
  #
  def link
    @project = Project.where(:scope => params[:scope], :name => params[:name]).first
    can_access? @project
    session[:selected_project] = @project.id
    github = Github.new :oauth_token => current_user.token
    @repos = github.repos.list
    @github = Repo.new
    render :action => 'create'
  end

  #
  #
  #
  def list
    @projects = Project.where(:user_id => current_user.id)
  end

  #
  #
  #
  def grant
    can_access? Project.where(:scope => params[:scope], :name => params[:name]).first
    if !params[:user].nil?
      userToAdd = User.where("login = '#{params[:user][:login]}'").first
      if !userToAdd.nil?
        project = Project.where(:scope => params[:scope], :name => params[:name]).first
        if userToAdd.grant_access project
          redirect_to({:action => 'show', :id => params[:project_id]})
        else
          flash[:error] = 'User doesn\'t exist or already has access to this project'
        end
      end
    end
    @user = User.new
  end

  #
  #
  #
  def revoke
    project = Project.where(:scope => params[:scope], :name => params[:name]).first
    can_access? project
    user = User.find(params[:user_id])
    if project.users.include? user
      project.users.delete(user)
      redirect_to({:action => 'show', :id => params[:project_id]})  unless project.save
    end
    flash[:notice] = 'User has no access to this project'
    redirect_to({:action => 'show', :id => params[:project_id]})
  end

  #
  #
  #
  def new
    @project = Project.new
  end

  #
  #
  #
  def edit
    if !params[:project].nil?
      @project = Project.where(:scope => params[:scope], :name => params[:name]).first
      can_access? @project
      params[:project].each do |key,value|
        @project[key] = value if @project.attribute_names.include?(key.to_s)
      end
      @project.save
      flash[:notice] = "Successfuly saved!"
    end
    @project = Project.where(:scope => params[:scope], :name => params[:name]).first if @project.nil?
    can_access? @project
  end

  #
  #
  #
  def show
    @project = Project.where(:scope => params[:scope], :name => params[:name]).first
    can_access? @project
  end

  #
  #
  #
  def unlink
    @github = Repo.find(params[:repo_id])
    @project = @github.project
    can_access? @project
    @project.issues.destroy_all
    redirect_to :action => 'show', :scope => @project.scope, :name => @project.name if @github.delete
  end

  def select_project
    @project = Project.find(params[:project_id])
    can_access? @project
    session[:selected_project] = @project.id
  end
end
