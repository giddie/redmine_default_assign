class AddDefaultAssigneeToProject < ActiveRecord::Migration[4.2]
  def self.up
    # Work around migration name change (Github issue #27)
    old_num = '20090508035844'
    num_deleted =
      ::ActiveRecord::Base.connection.delete(<<-SQL.squish)
        delete from schema_migrations
        where version = '#{old_num}-redmine_default_assign'
      SQL
    return  if num_deleted > 0
    add_column :projects, :default_assignee_id, :integer
  end

  def self.down
    remove_column :projects, :default_assignee_id
  end
end
