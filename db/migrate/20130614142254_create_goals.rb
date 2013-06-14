class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.integer :project_id
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
