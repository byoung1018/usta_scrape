class CreatePlayers < ActiveRecord::Migration[5.0]
  def change
    create_table :players do |t|
      t.string :fname
      t.string :lname
      t.string :name
      t.integer :usta_number
      t.string :city
      t.string :gender
      t.date :expiration_date
      t.date :last_complete_save
      t.timestamps
    end
  end
end
