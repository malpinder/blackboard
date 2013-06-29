class UserProjectsController < ApplicationController
  before_filter :authenticate!

  # POST /user_projects
  def create
    project = Project.find(params[:project_id])
    user_project = current_user.user_projects.build(project: project)

    set_flash_message(user_project.save, "Great! Mark each feature as done when you've completed it.")
    redirect_to(project_path(project))
  end

  # DELETE /user_projects/1
  def destroy
    user_project = current_user.user_projects.find(params[:id])
    project = user_project.project

    set_flash_message(user_project.destroy, "Okay, that project has been taken off your account.")
    redirect_to(project_path(project))
  end

  private

  def set_flash_message(success, notice)
    if success
      flash[:notice] = notice
    else
      flash[:warning] = 'Sorry, something went wrong there. Perhaps try again?'
    end
  end
end
