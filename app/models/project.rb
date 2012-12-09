class Project < ActiveRecord::Base
  attr_accessible :description, :name, :scope
  validates :description,  :presence => true
  validates_format_of :name, :with => /^[A-Za-z\d_-]+$/
  validates :name, :presence => true
  belongs_to :user
  has_many :repos
  has_many :user_stories
  has_many :user_story_types
  has_many :user_story_statuses
  has_many :issues
  has_and_belongs_to_many :users

  # Public : bind data when creating the project
  #
  # No parameters
  #
  # Examples :
  # project.bind
  #
  # Return reference to the project
  def bind_on_create user
    self.user = user
    self.scope = user.login
    return self
  end
end
