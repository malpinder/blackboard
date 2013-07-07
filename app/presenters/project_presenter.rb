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



end