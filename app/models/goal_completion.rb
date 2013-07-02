class GoalCompletion < ActiveRecord::Base
  belongs_to :goal
  belongs_to :user_project

  validates :user_project_id, presence: true
  validates :goal_id, presence: true, uniqueness: { scope: :user_project_id }
end
