class DefaultAssignIssueHook < Redmine::Hook::ViewListener
  def view_issues_form_details_top(context = {})
    # We only want to modify new issues; new issues haven't been assigned an id
    return  if not context[:issue].id.nil?

    # Don't do anything if we don't want interactive assignment
    interactive_assignment =
      Setting.plugin_redmine_default_assign['interactive_assignment'] || 'true'
    interactive_assignment = (interactive_assignment == 'true')
    return  if not interactive_assignment

    if not context[:project].default_assignee.blank?
      default_assignee = context[:project].default_assignee
      if context[:project].assignable_users.include?(default_assignee)
        context[:issue].assigned_to_id = default_assignee.id
      end
    else
      if context[:project].assignable_users.include?(User.current)
        context[:issue].assigned_to_id = User.current.id
      end
    end

    nil
  end  
end
