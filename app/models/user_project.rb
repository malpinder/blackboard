class UserProject < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  has_many :goal_completions, dependent: :destroy
  has_many :goals, through: :goal_completions

  validates :project_id, :user_id, presence: true

  delegate :display_name, to: :user

  def complete?
    goal_completions.count == project.goals.count
  end
end
