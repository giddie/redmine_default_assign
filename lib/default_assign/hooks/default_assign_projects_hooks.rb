class DefaultAssignProjectHook < Redmine::Hook::ViewListener
 
  # context:
  # * :form - the form builder
  # * :project - the current project
  def view_projects_form(context={})
    return  if context[:project].assignable_users.empty?
    selected = context[:project].default_assignee.id unless context[:project].default_assignee.blank?
    selected ||= Setting.plugin_redmine_default_assign['default_assignee_id'] unless Setting.plugin_redmine_default_assign['default_assignee_id'].blank? or 
										      not context[:project].assignable_users.member?(User.find(Setting.plugin_redmine_default_assign['default_assignee_id']).id)
    selected ||= nil
    if context[:project].assignable_users.any?
      return content_tag(:p, context[:form].select(:default_assignee_id,  
        options_from_collection_for_select(context[:project].assignable_users, :id, :name,
        unless selected.blank?
          Integer(selected)
        end
        ), {:include_blank => :none}))
    end
 
  end

end
