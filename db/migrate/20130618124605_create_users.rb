class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uid, allow_nil: false
      t.string :provider
      t.string :nickname
      t.string :name
      t.string :image_url
      t.string :github_url

      t.timestamps
    end
  end
end
