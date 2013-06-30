class GoalCompletionsController < ApplicationController
  def create
    goal = Goal.find(params[:goal_id])
    user_project = UserProject.find(params[:user_project_id])
    GoalCompletion.create(goal: goal, user_project: user_project)
    redirect_to(project_path(goal.project), notice: "You've marked that goal as complete.")
  end
end
