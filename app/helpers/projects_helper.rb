module ProjectsHelper

  def user_project_message(project)
    if user_signed_in?
      if current_user.projects.include?(project)
        content_tag(:span, "You're working on this project.") +
          no_longer_working_on_this_button(current_user, project) +
          content_tag(:span, "Your project is #{percentage_completion(project)}")
      else
        button_to "I want to start work on this", user_projects_path(project_id: project.id), class: "btn"
      end
    else
      content_tag(:span, "Want to let people know you're working in this project? ") + link_to("Log in via GitHub", new_session_path(provider: "github"))
    end
  end

  def no_longer_working_on_this_button(user, project)
    button_to(
      "I'm not working on this any more",
      user_project_path(user.user_projects.find_by_project_id(project.id)),
      method: :delete,
      class: "btn"
    )
  end

  def percentage_completion(project)
    user_project = project.user_projects.find_by(user_id: current_user.id) if user_signed_in?
    percentage = (user_project.goal_completions.count.to_f / project.goals.count) * 100 if project.goals.count > 0
    "#{percentage.to_i || 0}% complete."
  end
end