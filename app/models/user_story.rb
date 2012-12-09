class UserStory < ActiveRecord::Base
  attr_accessible :title, :description, :identifier, :position, :use_cases, :acceptance_tests, :current_sprint, :next_sprint, :historized, :historized_date
  attr_accessible :user_story_type_id, :user_story_status_id
  validates :title,  :presence => true
  validates :description, :presence => true
  belongs_to :user
  belongs_to :project
  belongs_to :user_story_type
  belongs_to :user_story_status
  has_many :issues, :foreign_key => "user_story_identifier_id", :primary_key => "identifier"
end
