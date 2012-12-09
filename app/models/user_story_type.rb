class UserStoryType < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name
  belongs_to :project
  has_many :user_stories
end
