require 'spec_helper'

feature "Starting a project" do
  background do
    OmniAuth.config.add_mock(:github, example_omniauth_github_response)
  end

  let(:project) {FactoryGirl.create(:project)}
  scenario "as a guest user" do
    visit project_path(project)

    page.should have_content "Want to let people know you're working in this project? Log in via GitHub"
    page.should have_no_button "I want to start work on this"
  end

  scenario "as a logged in user" do
    visit root_path
    click_link "Log in via GitHub"

    visit project_path(project)

    page.should have_button "I want to start work on this"
    click_button "I want to start work on this"

    page.should have_content "Great! Mark each feature as done when you've completed it."
    page.should have_content "You're working on this project."
    page.should have_no_button "I want to start work on this"
  end
end