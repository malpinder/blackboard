class Group < ActiveRecord::Base

  has_many :projects, ->{ order(id: :asc) }

end
