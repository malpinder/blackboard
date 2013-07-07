require 'spec_helper'


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
    log_in

    visit project_path(project)

    expect(page).to have_content("Grace H is working on this")
  end

  scenario "a logged in user who has started this project can't see themselves" do
    log_in

    visit project_path(project)
    click_button "I want to start work on this"

    expect(page).to have_no_content("Ada L is working on this")
  end

end