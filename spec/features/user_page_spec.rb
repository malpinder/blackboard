require 'spec_helper'

feature "A user page" do
  let(:user) { FactoryGirl.create(:user, name: "Ada L") }
  background do
    OmniAuth.config.add_mock(:github, omniauth_github_response_for(user))
  end

  scenario "lists all the information we have about them" do
    visit user_path(user)
    expect(page).to have_content user.display_name
    expect(page).to have_xpath("//img[@src=\"#{user.image_url}\"]")
    expect(page).to have_xpath("//a[@href=\"#{user.github_url}\"]")
  end

  scenario "lists projects they are working on in order of most-recent first" do
    older_project = FactoryGirl.create(:project, name: "Older project", started_by: [user])
    newer_project = FactoryGirl.create(:project, name: "Newer project", started_by: [user])

    visit user_path(user)
    expect(page).to have_css("ul#working-on li:first-child", text: newer_project.name)
    expect(page).to have_css("ul#working-on li:last-child", text: older_project.name)
  end

  scenario "lets you delete your account & data" do
    project = FactoryGirl.create(:project, name: "Project", started_by: [user])
    log_in
    visit user_path(user)

    expect(page).to have_button("Delete my account")

    click_button "Delete my account"

    expect(current_path).to eq root_path
    expect(page).to have_content "Log in"

    visit project_path(project)
    expect(page).to have_no_content(user.display_name)
  end

  scenario "does not let you delete other people's accounts" do
    grete = FactoryGirl.create(:user, nickname: "greteh")
    visit user_path(grete)
    expect(page).to have_no_button("Delete my account")

    log_in
    visit user_path(grete)
    expect(page).to have_no_button("Delete my account")
  end


end