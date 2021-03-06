module TeamsHelper
  def can_manage_team?(team)
    current_user.admin? || team.owners.exists?(current_user.id)
  end

  def role_within_team(team)
    team_user = team.team_users.find_by(user_id: current_user.id)
    if team_user
      team_user.role.titleize
    else
      # That happens when the admin user access a team he's not part of
      "-"
    end
  end

  # Render the namespace scope icon.
  def team_scope_icon(team)
    if team.team_users.count > 1
      icon = "fa-users"
      title = "Team"
    else
      icon = "fa-user"
      title = "Personal"
    end

    content_tag :i, "", class: "fa #{icon} fa-lg", title: title
  end

  # Render the team user role icon.
  def team_user_role_icon(team_user)
    icon = case team_user.role
           when "owner"
             "fa-key"
           when "contributor"
             "fa-exchange"
           when "viewer"
             "fa-eye"
           end

    content_tag :i, "", class: "fa #{icon} fa-lg", title: team_user.role.titleize
  end
end
