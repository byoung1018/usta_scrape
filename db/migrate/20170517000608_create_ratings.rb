class CreateRatings < ActiveRecord::Migration[5.0]
  def change
    create_table :ratings do |t|
      t.integer :player_id
      t.string :rating_type
      t.integer :year
      t.string :level
      t.timestamps
    end
  end
end
