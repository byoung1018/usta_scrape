class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.integer :captain_id
      t.integer :co_captain_id
      t.string :area
      t.string :home_facility_id
      t.string :organization_id
      t.string :name
      t.integer :division_id
      t.timestamps
    end
  end
end
