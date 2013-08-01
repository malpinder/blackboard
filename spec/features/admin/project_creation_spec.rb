require 'spec_helper'

feature "Creating a project", js: true do
  scenario "An admin user can create a project" do
    admin = FactoryGirl.create(:user, :admin, name: "Grace H", nickname: "graceh")
    OmniAuth.config.add_mock(:github, omniauth_github_response_for(admin))
    log_in

    visit new_project_path

    fill_in "Name", with: "Test Project"
    fill_in "Summary", with: "A project for testing."
    fill_in "Description", with: "This will tell us that an admin user can create projects."

    click_link "Add a goal"

    within ".goal_fields" do
      fill_in "Title", with: "A test goal"
      fill_in "Description", with: "A goal for testing."
      fill_in "Tips", with: "Write tests first!"
    end

    click_button "Create Project"

    expect(page).to have_content("Project was successfully created.")
    expect(page).to have_content("Test Project")
    expect(page).to have_content("A project for testing.")
    expect(page).to have_content("This will tell us that an admin user can create projects.")

    expect(page).to have_content("A test goal")

    click_link 'A test goal'
    expect(page).to have_content("A goal for testing.")

    click_link 'Tips'
    expect(page).to have_content("Write tests first!")
  end
end
