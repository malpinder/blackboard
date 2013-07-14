class ProjectPresenter

  attr_accessor :project, :user

  def initialize(project, user=nil)
    @project = project
    @user = user
  end

  def can_complete_goals?
    current_user_project.present?
  end

  def current_user_project
    return nil if user.nil?
    user.user_projects.find_by(project_id: project.id)
  end

  def worked_on_user_projects
    user_projects.reject(&:complete?)
  end

  def completed_user_projects
    user_projects.select(&:complete?)
  end

  def user_projects
    return @user_projects if @user_projects
    @user_projects = @project.user_projects.order(created_at: :desc)
    @user_projects = @user_projects.where.not(user_id: user.id) if user.present?
    @user_projects
  end

end