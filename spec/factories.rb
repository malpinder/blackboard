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

  factory :goal do
    project
  end

  factory :user_project do
    user
    project

    trait :in_progress do
      ignore do
        goal_completions_count { project.goals.count - 1 }
      end
      after(:create) do |user_project, evaluator|
        goals = user_project.project.goals.limit(evaluator.goal_completions_count)
        goals.each do |goal|
          FactoryGirl.create(:goal_completion, user_project: user_project, goal: goal)
        end
      end
    end

    trait :complete do
      goal_completions_count { project.goals.count }
      in_progress
    end
  end

  factory :goal_completion do
    goal
    user_project
  end
end