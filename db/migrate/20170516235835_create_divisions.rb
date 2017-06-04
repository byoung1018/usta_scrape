class CreateDivisions < ActiveRecord::Migration[5.0]
  def change
    create_table :divisions do |t|
      t.string :age_group
      t.string :division_type
      t.string :year
      t.string :level
      t.string :gender
      t.string :label
      t.date :last_complete_save

      t.timestamps
    end
  end
end
