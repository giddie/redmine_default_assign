require 'redmine'

# Including dispatcher.rb in case of Rails 2.x
require 'dispatcher' unless Rails::VERSION::MAJOR >= 3

require 'default_assign_issue_patch'
require 'default_assign_project_patch'
require 'default_assign/hooks/default_assign_projects_hooks'
require 'default_assign/hooks/default_assign_issues_hooks.rb'

if Rails::VERSION::MAJOR >= 3
  ActionDispatch::Callbacks.to_prepare do
    require_dependency 'project'
    require_dependency 'issue'
    Project.send(:include, DefaultAssignProjectPatch)
    Issue.send(:include, DefaultAssignIssuePatch)
  end
else
  Dispatcher.to_prepare do
    require_dependency 'project'
    require_dependency 'issue'
    Project.send(:include, DefaultAssignProjectPatch)
    Issue.send(:include, DefaultAssignIssuePatch)
  end
end

Redmine::Plugin.register :redmine_default_assign do
  name 'Default Assign plugin'
  author 'Robert Chady / Paul Dann'
  author_url 'https://github.com/giddie/redmine_default_assign'
  description 'Plugin implementing Douglas Campos\' ticket-482 code as a plugin.  It has since been extended to offer other features as well.'
  version '0.5'

  settings :default => {'default_assignee_id' => nil,
                        'interactive_assignment' => true},
           :partial => 'settings/default_assign'
end
