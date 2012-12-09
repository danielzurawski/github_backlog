module BacklogHelper

  def update_issues github, repo, project
    last_check = Time.parse("2001-10-20 00:00:00")
    last_check = repo.last_check.to_time.utc unless repo.last_check.nil?
    since = last_check.to_time.utc
    logger.info since.inspect
    repo.last_check = Time.now
    repo.save
    issues = find_closed_issues github, repo, since
    STDOUT << since.inspect
    issues.each{ |issue|
      update_backlog_issue issue, repo, project
    } if !issues.nil?

    issues = find_open_issues github,repo,since
    STDOUT << issues.inspect
    issues.each{ |issue|
      update_backlog_issue issue, repo, project
    } if !issues.nil?

  end


  def find_closed_issues github,repo, since
    
    begin
      issues = github.issues.list ({:filter => 'all', :since => since.strftime("%Y-%m-%dT%H:%M:%SZ"), :state => 'closed', :user => repo.owner, :repo => repo.repo}) 
    rescue
      issues = nil
    end
    return issues
  end

  def find_open_issues github,repo, since
    begin
      issues = github.issues.list ({:filter => 'all', :since => since.strftime("%Y-%m-%dT%H:%M:%SZ"), :user => repo.owner, :repo => repo.repo})
    rescue
      issues = nil
    end
    return issues
  end

  def update_backlog_issue issue, repo, project
    match = issue.title.scan(/GB #\d+/)
    if !match[0].nil?
      iss = repo.issues.where(:github_number => issue.number, :repo_id => repo, :project_id => project).first || Issue.new
      iss.title = issue.title
      iss.title = issue.title[issue.title.index(/\d+/)+issue.title.scan(/\d+/)[0].to_s.length+1..issue.title.length].strip
      iss.github_number = issue.number
      iss.github_assignee = issue.assignee.login unless issue.assignee.nil?
      iss.github_url = issue.html_url
      iss.state = issue.state
      iss.project = project
      iss.user_story_identifier_id = match[0].scan(/\d+/)[0].to_i
      iss.repo = repo
      iss.save
    end
  end
end
