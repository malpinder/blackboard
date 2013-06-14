class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :group_id
      t.string :name
      t.string :summary
      t.text :description

      t.timestamps
    end
  end
end
