require 'spec_helper'

feature "Viewing a project someone has started" do
  let(:user) { FactoryGirl.create(:user, name: "Grace H") }
  let(:project) {FactoryGirl.create(:project, started_by: [user])}

  scenario "a guest user can see them" do
    visit project_path(project)

    within "#working-users" do
      expect(page).to have_content("#{user.name} started work on this")
    end
  end

  scenario "it has a link to the user page" do
    visit project_path(project)
    within "#working-users" do
      expect(page).to have_link(user.display_name, href: user_path(user))
    end
  end

  scenario "a logged in user can see them" do
    OmniAuth.config.add_mock(:github, example_omniauth_github_response)
    log_in

    visit project_path(project)

    within "#working-users" do
      expect(page).to have_content("#{user.name} started work on this")
    end
  end

  scenario "a logged in user who has started this project can't see themselves" do
    OmniAuth.config.add_mock(:github, omniauth_github_response_for(user))
    log_in

    visit project_path(project)

    expect(page).to have_no_content("#{user.name} started work on this")
  end
end

feature "Viewing a project someone has finished" do
  let(:user) { FactoryGirl.create(:user, name: "Barbara L", nickname: "barbaral") }
  let(:project) {FactoryGirl.create(:project, completed_by: [user])}

  scenario "doesn't show them in the working-users list" do
    visit project_path(project)

    within "#working-users" do
      expect(page).to have_no_content(user.name)
    end
  end

  scenario "a guest user can see them in the finished users list" do
    visit project_path(project)

    within "#finished-users" do
      expect(page).to have_content("#{user.name} has completed this project")
    end
  end

  scenario "it has a link to the user page" do
    visit project_path(project)
    within "#finished-users" do
      expect(page).to have_link(user.display_name, href: user_path(user))
    end
  end

  scenario "a logged in user can see them" do
    OmniAuth.config.add_mock(:github, example_omniauth_github_response)
    log_in

    visit project_path(project)

    within "#finished-users" do
      expect(page).to have_content("#{user.name} has completed this project")
    end
  end

  scenario "a logged in user who has started this project can't see themselves" do
    OmniAuth.config.add_mock(:github, omniauth_github_response_for(user))
    log_in

    visit project_path(project)

    expect(page).to have_no_content("#{user.name} has completed this project")
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

  scenario "the user can edit the link" do
    OmniAuth.config.add_mock(:github, omniauth_github_response_for(barbara))
    repo_url = "https://github.com/#{barbara.nickname}/repo"
    log_in
    visit project_path(project)
    fill_in "URL", with: repo_url
    click_button "Add"

    fill_in "URL", with: "https://github.com/#{barbara.nickname}/repo2"
    click_button "Edit"
    expect(page).to have_no_xpath("//a[@href=\"#{repo_url}\"]")
    expect(page).to have_xpath("//a[@href=\"https://github.com/#{barbara.nickname}/repo2\"]")
  end
end

feature "Creating a project" do
  scenario "An admin user can create a project" do
    admin = FactoryGirl.create(:user, :admin, name: "Grace H", nickname: "graceh")
    OmniAuth.config.add_mock(:github, omniauth_github_response_for(admin))
    log_in
    visit new_project_path
    fill_in "Name", with: "Test Project"
    fill_in "Summary", with: "A project for testing."
    fill_in "Description", with: "This will tell us that an admin user can create projects."
    click_button "Create Project"
    expect(page).to have_content("Project was successfully created.")
    expect(page).to have_content("Test Project")
    expect(page).to have_content("A project for testing.")
    expect(page).to have_content("This will tell us that an admin user can create projects.")
  end
end
