class Goal < ActiveRecord::Base

  belongs_to :project

  has_many :goal_completions, dependent: :destroy

end
