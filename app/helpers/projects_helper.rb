module ProjectsHelper

  def get_started_message(project)
    if user_signed_in?
      if current_user.projects.include?(project)
        "You're working on this project."
      else
        button_to "I want to start work on this", user_projects_path(project_id: project.id), class: "btn"
      end
    else
      content_tag(:span, "Want to let people know you're working in this project? ") + link_to("Log in via GitHub", new_session_path(provider: "github"))
    end
  end

end
