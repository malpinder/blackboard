class UserProjectsController < ApplicationController
  before_filter :authenticate!

  # POST /user_projects
  def create
    project = Project.find(params[:project_id])
    if current_user.projects << project
      redirect_to project_path(project), notice: "Great! Mark each feature as done when you've completed it."
    else
      redirect_to project_path(project), warning: 'Sorry, something went wrong there. Perhaps try again?'
    end
  end
end
