class PlanningController < ApplicationController
  include ApplicationHelper
  def index
    project = Project.where(:name => params[:name], :scope => params[:scope]).first
    can_access? project
    session[:selected_project] = project.id
  end

  def reorder
    status_in_progress = selected_project.user_story_statuses.where(:name => 'In progress').first
    status_ready = selected_project.user_story_statuses.where(:name => 'Ready to be implemented').first
    if !params[:backlog].nil? then
      params[:backlog].each_with_index { |id, index|
        UserStory.update_all(['next_sprint=?, current_sprint=?,user_story_status_id=?', false, false, status_ready.id], ['id=?', id])
      }
    end
    if !params[:current].nil?  then
      params[:current].each_with_index { |id, index|
        UserStory.update_all(['next_sprint=?, current_sprint=?,user_story_status_id=?', false, true, status_in_progress.id], ['id=?', id])
      }
    end
    if !params[:next].nil? then
      params[:next].each_with_index { |id, index|
         UserStory.update_all(['next_sprint=?, current_sprint=?,user_story_status_id=?', true, false, status_ready.id], ['id=?', id])
  
    } end
    render nil
  end

  def card
    project = Project.where(:name => params[:name], :scope => params[:scope]).first
    can_access? project
    session[:selected_project] = project.id
    @user_story = UserStory.where(:identifier => params[:identifier], :project_id => project).first
    render :partial => 'shared/card'
  end

  def close
    project = Project.where(:name => params[:name], :scope => params[:scope]).first
    can_access? project
    session[:selected_project] = project.id
    user_stories_current =  UserStory.where(:current_sprint => true, :project_id => project)
    user_stories_current.each{|user_story|
      if user_story.user_story_status.name != 'Accepted' || user_story.user_story_status.name != 'Accepted'
        flash[:error] = 'All stories must be accepted or rejected before closing the sprint'
        (redirect_to(:back) and return)
      end
      UserStory.update_all(['current_sprint=?, historized=?, historized_date=?', false, true, DateTime.now], ['id=?', user_story.id])
    }
    status_in_progress = selected_project.user_story_statuses.where(:name => 'In progress').first
    user_stories_next =  UserStory.where(:next_sprint => true, :project_id => project)
    user_stories_next.each{|user_story|
      UserStory.update_all(['current_sprint=?, next_sprint=? , user_story_status_id=?',true, false, status_in_progress.id], ['id=?', user_story.id])
    }
    redirect_to :back
  end
end
