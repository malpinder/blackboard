class UserProjectsController < ApplicationController
  before_filter :authenticate!

  # POST /user_projects
  def create
    project = Project.find(params[:project_id])
    user_project = current_user.user_projects.build(project: project)

    set_flash_message(user_project.save, "Great! Mark each feature as done when you've completed it.")
    redirect_to(project_path(project))
  end

  def update
    set_flash_message(user_project.update(user_project_params), "Github repo saved.")
    redirect_to project_path(user_project.project)
  end

  # DELETE /user_projects/1
  def destroy
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

  def user_project
    @user_project ||= current_user.user_projects.find(params[:id])
  end

  def user_project_params
    params.require(:user_project).permit(:github_repo_url)
  end
end
