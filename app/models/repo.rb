class Repo < ActiveRecord::Base
  attr_accessible :owner, :repo, :project_id, :last_check
  validates :owner,  :presence => true
  validates :repo, :presence => true
  has_many :issues
  belongs_to :project
end
