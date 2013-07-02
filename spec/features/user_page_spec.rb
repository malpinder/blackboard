require 'spec_helper'

feature "A user page" do
  let(:user) { FactoryGirl.create(:user, name: "Ada L") }
  let(:worked_on_project) { FactoryGirl.create(:project, worked_on_by: [user])}
  background do
    OmniAuth.config.add_mock(:github, omniauth_github_response_for(user))
  end

  def expect_a_link_to_the_user_page
    expect(page).to have_link(user.display_name)
    click_link user.display_name
    expect(current_path).to eq(user_path(user))
  end

  scenario "is accessible from the navbar when logged in" do
    visit root_path
    click_link "Log in via GitHub"
    within ".user-nav" do
      expect_a_link_to_the_user_page
    end
  end

  scenario "is accessible from a project page they are working on" do
    visit project_path(worked_on_project)
    within "#working-users" do
      expect_a_link_to_the_user_page
    end
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
    expect(page).to have_css("ul#working-on:first-child", text: "Newer project")
    expect(page).to have_css("ul#working-on:last-child",  text: "Older project")
  end


end