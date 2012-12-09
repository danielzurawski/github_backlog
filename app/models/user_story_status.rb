class UserStoryStatus < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :name, :closed, :default
  belongs_to :project
  has_many :user_stories
end
