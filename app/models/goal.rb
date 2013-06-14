class Goal < ActiveRecord::Base

  belongs_to :projects
  has_many :tips

end
