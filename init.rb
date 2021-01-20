require 'redmine'

# Including dispatcher.rb in case of Rails 2.x
require 'dispatcher' unless Rails::VERSION::MAJOR >= 3

require 'default_assign_issue_patch'
require 'default_assign_project_patch'
require 'default_assign/hooks/default_assign_projects_hooks'
require 'default_assign/hooks/default_assign_issues_hooks.rb'

if Rails::VERSION::MAJOR >= 3
  ((Rails.version > "5")? ActiveSupport::Reloader : ActionDispatch::Callbacks).to_prepare do
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
  version '0.6'
  # The default project assignee functionality of this plugin has been added to
  # Redmine, see https://www.redmine.org/issues/482#note-62
  # Data from this plugin has been migrated to Redmine, you can remove this
  # plugin from Redmine versions 3.4.0 or higher
  #
  # Refuse to launch on Redmine version 3.4.0 or higher
  requires_redmine :version => '1.0'..'3.3'

  settings :default => {'default_assignee_id' => nil,
                        'interactive_assignment' => true,
                        'self_assignment' => false},
           :partial => 'settings/default_assign'
end
