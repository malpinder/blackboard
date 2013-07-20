class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :authenticate!, except: [:show, :index]
  before_action :authenticate_admin, except: [:show, :index]

  # GET /projects
  def index
    @projects = Project.all
  end

  # GET /projects/1
  def show
    @project_presenter = ProjectPresenter.new(@project, current_user)
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  def create
    @project = Project.new(project_params)

    if @project.save
      redirect_to @project, notice: 'Project was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /projects/1
  def update
    if @project.update(project_params)
      redirect_to @project, notice: 'Project was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /projects/1
  def destroy
    @project.destroy
    redirect_to projects_url, notice: 'Project was successfully destroyed.'
  end

  private

  def authenticate_admin
    render status: :forbidden, text: "You don't have permission to perform that action." unless current_user.admin?
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def project_params
    params.require(:project).permit(:group_id, :name, :summary, :description, goals_attributes: [:id, :title, :description, :project_id])
  end
end
