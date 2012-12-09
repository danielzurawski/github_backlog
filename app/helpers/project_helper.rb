module ProjectHelper

  def generate_default_data project
    ust1 = UserStoryType.new
    ust1.project = project
    ust1.name = "User story"
    ust1.save
    ust2 = UserStoryType.new
    ust2.project = project
    ust2.name = "Defect story"
    ust2.save
    ust3 = UserStoryType.new
    ust3.project = project
    ust3.name = "Technical story"
    ust3.save
    uss1 = UserStoryStatus.new
    uss1.name = "Draft"
    uss1.closed = false
    uss1.default = true
    uss1.project = project
    uss1.save
    uss2 = UserStoryStatus.new
    uss2.name = "Ready to be implemented"
    uss2.closed = false
    uss2.default = false
    uss2.project = project
    uss2.save
    uss3 = UserStoryStatus.new
    uss3.name = "In progress"
    uss3.closed = false
    uss3.default = false
    uss3.project = project
    uss3.save
    uss3 = UserStoryStatus.new
    uss3.name = "Accepted"
    uss3.closed = true
    uss3.default = false
    uss3.project = project
    uss3.save
    uss4 = UserStoryStatus.new
    uss4.name = "Rejected"
    uss4.default = false
    uss4.closed = true
    uss4.project = project
    uss4.save
  end
end
