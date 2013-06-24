FactoryGirl.define do
  factory :project

  factory :user do
    name "Ada L"
    nickname "ada"
    provider "github"
    uid "12345"
  end
end