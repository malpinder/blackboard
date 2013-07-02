require 'spec_helper'

feature "Starting a project" do
  background do
    OmniAuth.config.add_mock(:github, example_omniauth_github_response)
  end

  let(:project) {FactoryGirl.create(:project)}
  scenario "as a guest user" do
    visit project_path(project)

    expect(page).to have_content("Want to let people know you're working in this project? Log in via GitHub")
    expect(page).to have_no_button("I want to start work on this")
  end

  scenario "as a logged in user" do
    visit root_path
    click_link "Log in via GitHub"

    visit project_path(project)

    expect(page).to have_button("I want to start work on this")
    click_button "I want to start work on this"

    expect(page).to have_content("Great! Mark each feature as done when you've completed it.")
    expect(page).to have_content("You're working on this project.")
    expect(page).to have_no_button("I want to start work on this")
  end
end

feature "Finishing working on a project" do
  let(:user) {FactoryGirl.create(:user)}
  let(:project) {FactoryGirl.create(:project, started_by: [user], goals_count: 1)}

  background do
    OmniAuth.config.add_mock(:github, omniauth_github_response_for(user))
    visit root_path
    click_link "Log in via GitHub"
    visit project_path(project)
  end

  scenario "because I want to quit the project" do
    expect(page).to have_button("I'm not working on this any more")
    click_button "I'm not working on this any more"

    expect(page).to have_content("Okay, that project has been taken off your account.")
    expect(page).to have_no_content("You're working on this project.")
    expect(page).to have_button("I want to start work on this")
  end
end

feature "goal completion" do
  let(:user)    {FactoryGirl.create(:user)}
  let(:project) {FactoryGirl.create(:project, started_by: [user])}
  let(:goal)    { project.goals.first }

  background do
    OmniAuth.config.add_mock(:github, omniauth_github_response_for(user))
    visit root_path
    click_link "Log in via GitHub"
    visit project_path(project)
  end

  scenario "I can mark a goal as completed" do
    within("#goal-#{goal.id}") do
      expect(page).to have_button("I have done this goal")
    end
  end

  scenario "I can see completed goals as completed" do
    within("#goal-#{goal.id}") do
      click_button("I have done this goal")
    end

    expect(page).to have_content("You've marked that goal as complete.")

    within("#goal-#{goal.id}") do
      expect(page).to have_no_button("I have done this goal")
      expect(page).to have_content("\u2705") # The tick character
    end
  end
end

feature "Viewing a project someone has started" do
  background do
    OmniAuth.config.add_mock(:github, example_omniauth_github_response)
  end

  let(:user) { FactoryGirl.create(:user, name: "Grace H") }
  let(:project) {FactoryGirl.create(:project, started_by: [user])}

  scenario "a guest user can see them" do
    visit project_path(project)

    expect(page).to have_content("Grace H is working on this")
  end

  scenario "a logged in user can see them" do
    visit root_path
    click_link "Log in via GitHub"

    visit project_path(project)

    expect(page).to have_content("Grace H is working on this")
  end

  scenario "a logged in user who has started this project can't see themselves" do
    visit root_path
    click_link "Log in via GitHub"

    visit project_path(project)
    click_button "I want to start work on this"

    expect(page).to have_no_content("Ada L is working on this")
  end

end