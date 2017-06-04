class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.integer :captain_id
      t.integer :co_captain_id
      t.string :area
      t.integer :home_facility_id
      t.integer :organization_id
      t.string :name
      t.integer :division_id
      t.date :last_complete_save
      t.timestamps
    end
  end
end
