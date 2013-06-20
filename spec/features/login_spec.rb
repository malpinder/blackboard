require 'spec_helper'

feature "User sessions" do
  background do
    OmniAuth.config.add_mock(:github, example_omniauth_github_response)
  end
  scenario "logging in" do
    visit root_path
    page.should have_link('Log in via GitHub')

    click_link "Log in via GitHub"

    current_path.should eq root_path
    page.should have_content "Ada L"
    page.should have_xpath("//img[@src=\"https://example.gravatar.com/avatar/ada\"]")
  end

  scenario "logging out" do
    visit root_path
    click_link "Log in via GitHub"

    page.should have_link('Log out')
    click_link "Log out"

    page.should have_no_link('Log out')
    page.should have_no_content "Ada L"
    page.should have_no_xpath("//img[@src=\"https://example.gravatar.com/avatar/ada\"]")
  end
end