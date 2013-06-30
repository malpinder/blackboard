class GoalCompletion < ActiveRecord::Base
  belongs_to :goal
  belongs_to :user_project
end
