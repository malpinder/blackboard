module ProjectsHelper

  def status_partial_for_user_project(user_project)
    if current_user.nil?
      "projects/status/needs_login"
    elsif user_project.nil?
      "projects/status/ready"
    elsif user_project.complete?
      "projects/status/finished"
    else
      "projects/status/in_progress"
    end
  end

end