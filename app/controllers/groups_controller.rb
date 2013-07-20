class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :authenticate!, except: [:show, :index]
  before_action :authenticate_admin!, except: [:show, :index]

  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
  end

  def new
    @group = Group.new
  end

  def edit
  end

  def create
    @group = Group.new(group_params)

    if @group.save
      redirect_to @group, notice: 'Group was successfully created.'
    else
      render action: 'new'
    end
  end

  def update
    if @group.update(group_params)
      redirect_to @group, notice: 'Group was successfully updated.'
    else
      render action: 'edit'
    end
  end

  def destroy
    @group.destroy
    redirect_to group_url, notice: 'Group was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_group
    @group = Group.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def group_params
    params.require(:group).permit(:name)
  end
end
