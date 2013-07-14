require 'spec_helper'

feature "The nav bar" do
  let(:user) { FactoryGirl.create(:user, name: "Evelyn B G") }
  background do
    OmniAuth.config.add_mock(:github, omniauth_github_response_for(user))
  end

  scenario "has a link to the user page when logged in" do
    log_in
    within ".user-nav" do
      expect(page).to have_link(user.display_name)
      click_link user.display_name
      expect(current_path).to eq(user_path(user))
    end
  end
end
