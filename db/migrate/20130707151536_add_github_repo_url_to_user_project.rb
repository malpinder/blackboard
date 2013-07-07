class AddGithubRepoUrlToUserProject < ActiveRecord::Migration
  def change
    add_column :user_projects, :github_repo_url, :string
  end
end
