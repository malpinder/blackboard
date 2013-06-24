class UserProject < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  delegate :display_name, to: :user
end
