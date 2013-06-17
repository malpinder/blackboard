class Project < ActiveRecord::Base

  belongs_to :group
  has_many :goals
  accepts_nested_attributes_for :goals, reject_if: :all_blank, allow_destroy: true

end
