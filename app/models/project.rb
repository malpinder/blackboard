class Project < ActiveRecord::Base

  belongs_to :group
  has_many :goals, ->{ order(id: :asc) }
  accepts_nested_attributes_for :goals, reject_if: :all_blank, allow_destroy: true

  has_many :user_projects
  has_many :users, through: :user_projects

end
