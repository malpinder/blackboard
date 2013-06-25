require 'spec_helper'

feature "User sessions" do
  let(:user) { FactoryGirl.build(:user, image_url: "https://example.gravatar.com/avatar/ada") }
  background do
    OmniAuth.config.add_mock(:github, omniauth_github_response_for(user))
  end
  scenario "logging in" do
    visit root_path
    expect(page).to have_link('Log in via GitHub')

    click_link "Log in via GitHub"

    expect(current_path).to eq(root_path)
    expect(page).to have_content user.display_name
    expect(page).to have_xpath("//img[@src=\"#{user.image_url}\"]")
  end

  scenario "logging out" do
    visit root_path
    click_link "Log in via GitHub"

    expect(page).to have_link('Log out')
    click_link "Log out"

    expect(page).to have_no_link('Log out')
    expect(page).to have_no_content user.display_name
    expect(page).to have_no_xpath("//img[@src=\"#{user.image_url}\"]")
  end
end