class CreateTeamMemberships < ActiveRecord::Migration[5.0]
  def change
    create_table :team_memberships do |t|
      t.integer :team_id
      t.integer :player_id
      t.timestamps
    end
  end
end
