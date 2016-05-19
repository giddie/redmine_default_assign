class DefaultAssignIssueHook < Redmine::Hook::ViewListener
  def view_issues_form_details_top(context = {})
    # We only want to modify new issues; new issues haven't been assigned an id
    return  if not context[:issue].id.nil?

    # Don't do anything if we don't want interactive assignment
    interactive_assignment =
      Setting.plugin_redmine_default_assign['interactive_assignment'] || 'true'
    interactive_assignment = (interactive_assignment == 'true')
    return  if !interactive_assignment || Setting.plugin_redmine_default_assign[:override_category_assignee] != 'true'

    if context[:project].default_assignee.blank?
      self_assignment =
        Setting.plugin_redmine_default_assign['self_assignment'] || 'false'
      self_assignment = (self_assignment == 'true')
      default_assignee = User.current  if self_assignment
    else
      default_assignee = context[:project].default_assignee
    end
    if context[:project].assignable_users.include?(default_assignee)
      context[:issue].assigned_to_id = default_assignee.id
    end

    nil
  end  
end
