class User < ActiveRecord::Base

  has_many :user_projects
  has_many :projects, through: :user_projects

  def self.find_or_create_by_auth_hash(auth_hash)
    attributes = {
      provider: auth_hash[:provider],
      uid: auth_hash[:uid],
      name: auth_hash[:info][:name],
      nickname: auth_hash[:info][:nickname],
      github_url: auth_hash[:info][:urls]["GitHub"],
      image_url: auth_hash[:info][:image]
    }
    self.find_by_provider_and_uid(attributes[:provider], attributes[:uid]) || create!(attributes)
  end

end
