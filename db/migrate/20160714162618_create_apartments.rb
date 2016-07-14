class CreateApartments < ActiveRecord::Migration
  def change
    create_table :apartments do |t|
      t.integer :apartment_number
      t.date :lease_start
      t.date :lease_end
      t.timestamps
    end
  end
end
