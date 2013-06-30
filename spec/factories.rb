FactoryGirl.define do
  factory :project

  factory :user do
    name "Ada L"
    nickname "ada"
    provider "github"
    uid "12345"
    github_url "https://example.github.com/adal"
    image_url "https://example.gravatar.com/pictures/adal"
  end

  factory :goal
end