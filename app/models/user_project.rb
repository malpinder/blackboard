class UserProject < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  has_many :goal_completions, dependent: :destroy
  has_many :goals, through: :goal_completions

  delegate :display_name, to: :user
end
