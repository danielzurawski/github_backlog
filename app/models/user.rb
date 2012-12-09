
class User < ActiveRecord::Base

  attr_accessible :email, :name, :provider, :uid, :token, :login
  has_and_belongs_to_many :projects

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      if auth['info']
        user.name = auth['info']['name'] || ""
        user.email = auth['info']['email'] || ""
      end
      user.token = auth['credentials']['token'] || ""
      user.login = auth['info']['nickname']
    end
  end

  # Public : Grant access to a project for the user
  #
  # project : the project to give access to
  #
  # Example :
  # user.grant_access project
  #
  # Returns true if everything went fine
  def grant_access project
    
    if !self.projects.include? project
      self.projects << project
      return true
    else
      return false
    end
  end
end
