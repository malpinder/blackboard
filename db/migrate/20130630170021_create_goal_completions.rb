class CreateGoalCompletions < ActiveRecord::Migration
  def change
    create_table :goal_completions do |t|
      t.belongs_to :goal, index: true
      t.belongs_to :user_project, index: true

      t.timestamps
    end
  end
end
