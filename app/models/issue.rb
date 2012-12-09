class Issue < ActiveRecord::Base
  attr_accessible :state, :title, :github_number, :github_url, :github_assignee
  belongs_to :user_story, :foreign_key => "user_story_identifier_id", :primary_key => "identifier"
  belongs_to :repo
  belongs_to :project
end
