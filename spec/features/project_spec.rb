require 'spec_helper'


feature "Viewing a project someone has started" do
  background do
    OmniAuth.config.add_mock(:github, example_omniauth_github_response)
  end

  let(:user) { FactoryGirl.create(:user, name: "Grace H") }
  let(:project) {FactoryGirl.create(:project, started_by: [user])}

  scenario "a guest user can see them" do
    visit project_path(project)

    expect(page).to have_content("#{user.name} is working on this")
  end

  scenario "a logged in user can see them" do
    log_in

    visit project_path(project)

    expect(page).to have_content("#{user.name} is working on this")
  end

  scenario "a logged in user who has started this project can't see themselves" do
    log_in

    visit project_path(project)
    click_button "I want to start work on this"

    expect(page).to have_no_content("#{example_omniauth_github_response.info.name} is working on this")
  end
end

feature "Adding a Github repo link to a project" do
  let(:grace) { FactoryGirl.create(:user, name: "Grace H", nickname: "graceh") }
  let(:barbara) { FactoryGirl.create(:user, name: "Barbara L", nickname: "barbaral") }
  let(:project) {FactoryGirl.create(:project, started_by: [grace], completed_by: [barbara])}

  scenario "a guest user cannot add a link" do
    visit project_path(project)

    expect(page).to have_no_content("Add a GitHub repo")
  end
  scenario "a logged in user cannot if they have not started the project" do
    OmniAuth.config.add_mock(:github, example_omniauth_github_response)
    log_in
    visit project_path(project)

    expect(page).to have_no_content("Add a GitHub repo")
  end
  scenario "a logged in user can if they have started the project" do
    OmniAuth.config.add_mock(:github, omniauth_github_response_for(grace))
    log_in
    visit project_path(project)

    expect(page).to have_content("Add a GitHub repo")
    fill_in "URL", with: "https://github.com/#{grace.nickname}/repo"
    click_button "Add"

    expect(page).to have_xpath("//a[@href=\"https://github.com/#{grace.nickname}/repo\"]")
  end
  scenario "a logged in user can if they have completed the project" do
    OmniAuth.config.add_mock(:github, omniauth_github_response_for(barbara))
    log_in
    visit project_path(project)

    expect(page).to have_content("Add a GitHub repo")
    fill_in "URL", with: "https://github.com/#{barbara.nickname}/repo"
    click_button "Add"

    expect(page).to have_xpath("//a[@href=\"https://github.com/#{barbara.nickname}/repo\"]")
  end
end
