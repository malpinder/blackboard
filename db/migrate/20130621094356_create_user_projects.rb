class CreateUserProjects < ActiveRecord::Migration
  def change
    create_table :user_projects do |t|
      t.belongs_to :user, index: true
      t.belongs_to :project, index: true

      t.timestamps
    end
  end
end
