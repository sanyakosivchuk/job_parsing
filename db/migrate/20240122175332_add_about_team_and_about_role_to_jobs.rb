class AddAboutTeamAndAboutRoleToJobs < ActiveRecord::Migration[7.1]
  def change
    add_column :jobs, :about_team, :text
    add_column :jobs, :about_role, :text
  end
end
