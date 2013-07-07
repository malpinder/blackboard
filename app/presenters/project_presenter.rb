class ProjectPresenter

  attr_accessor :project, :user

  def initialize(project, user=nil)
    @project = project
    @user = user
  end

  def status
    if user.nil?
      :needs_login
    elsif user.has_completed?(project)
      :finished
    elsif user.working_on?(project)
      :in_progress
    else
      :ready
    end
  end

  def current_user_project
    return nil if user.nil?
    user.user_projects.find_by(project_id: project.id)
  end



end