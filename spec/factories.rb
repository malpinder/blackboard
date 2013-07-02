FactoryGirl.define do
  factory :project do
    ignore do
      goals_count 2
    end
    after(:create) do |project, evaluator|
      FactoryGirl.create_list(:goal, evaluator.goals_count, project: project)
    end
  end

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